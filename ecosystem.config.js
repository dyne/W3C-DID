// cwd to change directory from which js is launched
module.exports = {
    apps : [{
        name : "did",
        script : "./restroom.mjs",
        cwd: "restroom"
    },{
        name : "resolver",
        script: "./resolver.js",
        cwd: "resolver"
    }]
}
