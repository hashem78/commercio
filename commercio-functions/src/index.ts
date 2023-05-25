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

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
initializeApp();
const db = getFirestore();


export const emptyCart = onRequest(
  {timeoutSeconds: 15, cors: true, maxInstances: 10},
  async (req, res): Promise<any> => {
    const body = req.body.data;
    const uid: string = body.uid;

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
      });
    } catch (error) {
      console.log(error);
      return res.json(error);
    }

    res.send({}).end();
  });
