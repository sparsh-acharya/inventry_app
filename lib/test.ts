// import {onSchedule} from "firebase-functions/v2/scheduler";
// import * as admin from "firebase-admin";

// // Initialize the Firebase Admin SDK
// admin.initializeApp();
// const db = admin.firestore();
// const messaging = admin.messaging();

// /**
//  * A Cloud Function that runs daily to automate inventory tracking.
//  *
//  * This function queries all items with automation enabled, updates their
//  * counts based on the daily consumption rate, and sends notifications
//  * to group members when an item is about to run out.
//  */
// export const dailyItemAutomation = onSchedule("every day 05:00", async (event) => {
//     console.log("Starting daily item automation job...");

//     const today = new Date();
//     today.setHours(0, 0, 0, 0); // Normalize to the start of the day for consistent date comparisons

//     try {
//       // Use a collection group query to efficiently find all "items" subcollections
//       const itemsQuery = db
//         .collectionGroup("items")
//         .where("automationEnabled", "==", true);

//       const itemsSnapshot = await itemsQuery.get();

//       if (itemsSnapshot.empty) {
//         console.log("No automated items found. Job finishing.");
//         return;
//       }

//       const updatePromises: Promise<any>[] = [];

//       itemsSnapshot.forEach((doc) => {
//         const item = doc.data();

//         // Basic validation to prevent errors
//         if (!item.automationStartDate || item.itemCount <= 0) {
//           return;
//         }

//         const startDate = (item.automationStartDate as admin.firestore.Timestamp).toDate();
//         startDate.setHours(0, 0, 0, 0);

//         // Check if the automation period has started
//         if (startDate <= today) {
//           const newCount = item.itemCount - (item.consumptionRate || 0);

//           // Update the item count in Firestore
//           const updatePromise = doc.ref.update({
//             itemCount: newCount > 0 ? newCount : 0,
//           });
//           updatePromises.push(updatePromise);

//           // --- Notification Logic ---
//           // Calculate if the item will be depleted by the next day
//           if (newCount / (item.consumptionRate || 1) <= 1 && item.itemCount > 0) {
//             const groupRef = doc.ref.parent.parent;
//             if (groupRef) {
//               const notificationPromise = groupRef.get().then(async (groupDoc) => {
//                 const groupData = groupDoc.data();
//                 if (groupData && groupData.members) {
//                   await sendLowStockNotification(groupData.members, item.name);
//                 }
//               });
//               updatePromises.push(notificationPromise);
//             }
//           }
//         }
//       });

//       await Promise.all(updatePromises);
//       console.log("Daily item automation job completed successfully.");
//     } catch (error) {
//       console.error("Error running daily item automation job:", error);
//     }
//     return;
//   });

// /**
//  * Sends a "low stock" notification to a list of users.
//  *
//  * @param {string[]} memberUids - An array of user UIDs to send the notification to.
//  * @param {string} itemName - The name of the item that is running low.
//  */
// async function sendLowStockNotification(memberUids: string[], itemName: string) {
//   if (memberUids.length === 0) {
//     return;
//   }

//   // Get the FCM tokens for all members in the group
//   const tokensQuery = await db
//     .collection("users")
//     .where(admin.firestore.FieldPath.documentId(), "in", memberUids)
//     .get();

//   const tokens = tokensQuery.docs
//     .map((doc) => doc.data().fcmToken)
//     .filter((token): token is string => !!token);

//   if (tokens.length > 0) {
//     // Create the notification message payload
//     const message: admin.messaging.MulticastMessage = {
//       notification: {
//         title: "Inventory Alert",
//         body: `"${itemName}" is running low and will be finished by tomorrow!`,
//       },
//       tokens: tokens,
//     };

//     // Send the message to all devices
//     try {
//       const response = await messaging.sendEachForMulticast(message);
//       console.log(`Successfully sent low stock notification for "${itemName}" to ${response.successCount} devices.`);
//     } catch (error) {
//       console.error("Error sending FCM message:", error);
//     }
//   }
// }
