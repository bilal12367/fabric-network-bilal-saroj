import Express from "express";
import logger from "./logger/logger.js";
import router from "./router/router.js";

const app = Express();

app.use(Express.json());

app.use(router)

app.listen(5000, () => {
    logger.info("Server started listening at port 5000...")
})