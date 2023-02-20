import  express from "express";
import { createCar, getCar } from "../controller/chaincodeController.js";
import { registerIdentity } from "../controller/identityController.js";

const router  = express.Router();

router.route('/api/register').post(registerIdentity)

router.route('/api/addCar').post(createCar)

router.route('/api/getCar').get(getCar)

export default router;
