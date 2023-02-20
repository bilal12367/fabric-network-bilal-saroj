import Log4js from "log4js";

Log4js.configure({
    appenders: { 
        cheese: { type: "file", filename: "log1.log" } ,
        console: { type: 'console'}
    },
    categories: { default: { appenders: ["cheese","console"], level: "all" } },
});

export default Log4js.getLogger();