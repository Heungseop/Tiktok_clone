import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const onVideoCreated = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    // snapshot => 생성한 document
    const spawn = require("child-process-promise").spawn;
    const video = snapshot.data();
    await spawn("ffmpeg", [
      "-i",
      video.fileUrl,
      "-ss",
      "00:00:01.000",
      "-vframes",
      "1",
      "-vf",
      "scale=150:-1",
      `/tmp/${snapshot.id}.jpg`,
    ]); // tmp디렉토리에 임시 썸네일 추출 후 저장

    const storage = admin.storage();
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumnails/${snapshot.id}.jpg`,
    }); // destination에 썸네일 파일 저장

    await file.makePublic();
    await snapshot.ref.update({ thumbnailUrl: file.publicUrl() }); //video 콜렉션 데이터에 썸네일 유알엘 저장

    // 유저 프로필에서 모든 비디오를 검색하는 것은 비효율적이기 때문에
    // 유저 콜렉션에 역정규화
    const db = admin.firestore();
    await db
      .collection("users")
      .doc(video.creatorUid)
      .collection("videos")
      .doc(snapshot.id)
      .set({ thumbnailUrl: file.publicUrl(), videoId: snapshot.id });
  });

export const onLikedCreated = functions.firestore
  .document("likes/{likeId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, _] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      .update({ likes: admin.firestore.FieldValue.increment(1) });

    const video = await (
      await db.collection("videos").doc(videoId).get()
    ).data();

    if (video) {
      const creatorUid = video.creatorUid;
      const user = await (
        await db.collection("users").doc(creatorUid).get()
      ).data();
      if (user) {
        const token = user.token;
        await admin.messaging().send({
          token: token,
          data: { screen: "123" },
          notification: {
            title: "somone liked you video",
            body: "Likes +1!",
          },
        });
      }
    }
  });

export const onLikeRemoved = functions.firestore
  .document("likes/{likeId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, _] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      .update({ likes: admin.firestore.FieldValue.increment(-1) });
  });

// 메세지 전송 시 해당룸의 유저별 룸정보에 lastMsg, lastMsgDate 갱신
// 되긴 하는데 모든 메세지에 functions 호출하면 거덜나지 않을까..?
export const onSendMsgUpdateChatRoom = functions.firestore
  .document("chat_rooms/{roomId}")
  .onUpdate(async (change, context) => {
    const db = admin.firestore();
    const room = change.after.data();

    for (var idx in room.uidlist) {
      await db
        .collection("users")
        .doc(room.uidlist[idx])
        .collection("chat_room_list")
        .doc(room.roomId)
        .update({ lastMsg: room.lastMsg, lastMsgDate: room.lastMsgDate });
    }
  });
