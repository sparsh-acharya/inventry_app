import {onSchedule} from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";

// Initialize the Firebase Admin SDK
admin.initializeApp();
const db = admin.firestore();
const messaging = admin.messaging();

/**
 * A Cloud Function that runs every 5 minutes for testing automation.
 *
 * This function queries all items with automation enabled, updates their
 * counts based on the daily consumption rate, and sends notifications
 * to group members when an item's count is low.
 */
export const frequentItemAutomationForTesting = onSchedule("every 5 minutes", async (event) => {
    console.log("Starting frequent item automation job for testing...");

    const today = new Date();
    today.setHours(0, 0, 0, 0); // Normalize for date comparisons

    try {
      const itemsQuery = db
        .collectionGroup("items")
        .where("automationEnabled", "==", true);

      const itemsSnapshot = await itemsQuery.get();

      if (itemsSnapshot.empty) {
        console.log("No automated items found. Job finishing.");
        return;
      }

      const promises: Promise<any>[] = [];

      itemsSnapshot.forEach((doc) => {
        const item = doc.data();

        if (!item.automationStartDate || item.itemCount <= 0) {
          return; // Skip if automation hasn't started or item is already out of stock
        }

        const startDate = (item.automationStartDate as admin.firestore.Timestamp).toDate();
        startDate.setHours(0, 0, 0, 0);

        if (startDate <= today) {
          const newCount = item.itemCount - (item.consumptionRate || 0);
          const finalCount = newCount > 0 ? newCount : 0;

          // Update the item count in Firestore
          const updatePromise = doc.ref.update({ itemCount: finalCount });
          promises.push(updatePromise);

          // --- Modified Notification Logic for Testing ---
          // Send a notification if the count is below a threshold (e.g., 10)
          if (finalCount < 10 && item.itemCount > 0) {
            const groupRef = doc.ref.parent.parent;
            if (groupRef) {
              const notificationPromise = groupRef.get().then(async (groupDoc) => {
                const groupData = groupDoc.data();
                if (groupData && groupData.members) {
                  await sendLowStockNotification(groupData.members, item.name, finalCount);
                }
              });
              promises.push(notificationPromise);
            }
          }
        }
      });

      await Promise.all(promises);
      console.log("Frequent item automation job completed successfully.");
    } catch (error) {
      console.error("Error running frequent item automation job:", error);
    }
  });

/**
 * Sends a "low stock" notification to a list of users.
 */
async function sendLowStockNotification(memberUids: string[], itemName: string, remainingCount: number) {
  if (memberUids.length === 0) return;

  const tokensQuery = await db
    .collection("users")
    .where(admin.firestore.FieldPath.documentId(), "in", memberUids)
    .get();

  const tokens = tokensQuery.docs
    .map((doc) => doc.data().fcmToken)
    .filter((token): token is string => !!token);

  if (tokens.length > 0) {
    const message: admin.messaging.MulticastMessage = {
      notification: {
        title: "Inventory Alert (Test)",
        body: `"${itemName}" is running low! Only ${remainingCount} left.`,
      },
      tokens: tokens,
    };

    try {
      const response = await messaging.sendEachForMulticast(message);
      console.log(`Successfully sent low stock notification for "${itemName}" to ${response.successCount} devices.`);
    } catch (error) {
      console.error("Error sending FCM message:", error);
    }
  }
}
