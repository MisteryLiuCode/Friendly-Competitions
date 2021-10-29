import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as notifications from "./notifications";
import * as moment from "moment";
admin.initializeApp();

const firestore = admin.firestore();

exports.sendIncomingFriendRequestNotification = functions.firestore
    .document("users/{userId}")
    .onUpdate(async change => {
        const user = change.after.data();
        const newFriendRequests: string[] = user.incomingFriendRequests;
        const oldFriendRequests: string[] = change.before.data().incomingFriendRequests;

        if (newFriendRequests == oldFriendRequests) {
            return null;
        }

        const incomingFriends = newFriendRequests
            .filter((x: string) => !oldFriendRequests.includes(x))
            .map(incomingFriendId => {
                return admin.auth().getUser(incomingFriendId);    
            });

        return Promise.all(incomingFriends)
            .then(incomingFriends => {
                const notificationPromises = incomingFriends.map(incomingFriend => {
                    return notifications.sendNotifications(
                        user.id, 
                        "Friendly Competitions",
                        `${incomingFriend.displayName} added you as a friend`
                    );
                });
                return Promise.all(notificationPromises);
            });
    });

exports.sendNewCompetitionNotification = functions.firestore
    .document("competitions/{competitionId}")
    .onCreate(async snapshot => {
        const creatorPromise = await firestore.doc(`users/${snapshot.data().participants[0]}`).get();
        const creator = creatorPromise.data();
        const pendingParticipants: string[] = snapshot.data().pendingParticipants;

        if (creator == null) {
            return;
        }

        const pendingParticipantPromises = pendingParticipants.map(pendingParticipant => {
            return firestore.doc(`users/${pendingParticipant}`).get();
        });

        return Promise.all(pendingParticipantPromises)
            .then(pendingParticipants => {
                
                if (pendingParticipants == null) {
                    return null;
                }

                const notificationPromises = pendingParticipants.map(pendingParticipant => {
                    const user = pendingParticipant.data();   
                    
                    if (user == null) {
                        return Promise.resolve();
                    }

                    return notifications.sendNotifications(
                        user.id,
                        "Friendly Competitions",
                        `${creator.name} invited you to a competition`
                    );
                });

                return Promise.all(notificationPromises);
            });
    });

exports.scheduledFunction = functions.pubsub.schedule("every day 12:00")
    .timeZone("America/Toronto")
    .onRun(async context => {
        const yesterday = moment().utc().subtract(1, "day");
        
        const competitionsRef = await firestore.collection("competitions").get();

        const competitionPromises = competitionsRef.docs.map(async competitionDoc => {
            const competition = competitionDoc.data();
            const competitionEnd = moment(competition.end);

            if (yesterday.dayOfYear() != competitionEnd.dayOfYear() || yesterday.year() != competitionEnd.year()) {
                return;
            }

            console.log(`Sending standing notification for competition: ${competition.name}`);

            const standingsRef = await firestore.collection(`competitions/${competition.id}/standings`).get();
            const standings = standingsRef.docs.map(doc => {
                return doc.data();
            });

            /**
             * Returns a ordinal representation for a given number
             * @param {number} n number to get ordinal string for
             * @return {string} ordinal representation of number
             */
            function nth(n: number) {
                return ["st", "nd", "rd"][((n+90)%100-10)%10-1] || "th";
            }

            const notificationPromises = competition.participants.map((participantId: string) => {
                const standing = standings.find(standing => {
                    return standing.userId == participantId;
                });

                if (standing == null) {
                    return Promise.resolve();
                }

                const rank = standing.rank;

                return notifications.sendNotifications(
                    participantId,
                    "Friendly Competitions",
                    `Completion complete! You placed ${rank}${nth(rank)} in ${competition.name}!`
                );
            });

            return Promise.all(notificationPromises);
        });

        return Promise.all(competitionPromises);
    });
