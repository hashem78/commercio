/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onRequest} from "firebase-functions/v2/https";

import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {initializeApp} from "firebase-admin/app";
import {v4 as uuidv4} from "uuid";
import {
  onDocumentDeleted,
} from "firebase-functions/v2/firestore";
import {setGlobalOptions} from "firebase-functions/v2/options";
// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
initializeApp();
const db = getFirestore();
setGlobalOptions({maxInstances: 10});

export const emptyCart = onRequest(
  {timeoutSeconds: 15, cors: true, maxInstances: 10},
  async (req, res): Promise<any> => {
    const body = req.body.data;
    const uid: string = body.uid;
    const location = body.location;

    try {
      console.log(uid);

      const products: any[] = [];
      const cartCollectionRef = db.collection(`/users/${uid}/cart`);

      const documents = await cartCollectionRef.listDocuments();
      for (const cartEntryDoc of documents) {
        const cartEntrySnapshot = await cartEntryDoc.get();
        const cartEntry: any = cartEntrySnapshot.data();
        const product = `/shops/${cartEntry.shopId}/products/${cartEntry.id}`;
        const productSnapshot = await db.doc(product).get();

        products.push(productSnapshot.data());
      }

      await db.doc(`/users/${uid}`).set({
        cartDetails: {
          itemCount: 0,
          totalPrice: 0,
        },
      }, {
        merge: true,
      });

      const uuid = uuidv4();
      let totalPrice = 0;
      for (const product of products) {
        totalPrice += product.price;
      }

      await db.recursiveDelete(cartCollectionRef);
      await db.doc(`/users/${uid}/purchases/${uuid}`).set({
        id: uuid,
        createdOn: FieldValue.serverTimestamp(),
        products: products,
        totalPrice: totalPrice,
        location: location,
      });
      res.send({data: {}}).end();
    } catch (error) {
      console.log(error);
      res.send({data: {error: error}});
    }
  });

const onProductDeletedPath = "/shops/{shopId}/products/{productId}";

export const onProductDeleted = onDocumentDeleted(
  onProductDeletedPath, async (event) => {
    const snap = event.data;

    if (snap === undefined) return;
    const {productId} = event.params;

    const usersCollectionRef = await db.collection("/users").listDocuments();

    for (const docRef of usersCollectionRef) {
      const doc = await docRef.get();
      const user: any = doc.data();
      const userId: string = user.id;

      await db.doc(`/users/${userId}/likedProducts/${productId}`).delete();
    }
  });

export const deleteShop = onRequest(async (req, res) => {
  const body = req.body.data;
  const shopId: string = body.shopId;

  const shopRef = db.doc(`/shops/${shopId}`);

  await db.recursiveDelete(shopRef);

  res.send({data: {}}).end();
});
