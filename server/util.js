function Utils() {

    this.userList = []

}
Utils.prototype = {
    constructor: Utils,
    addUser: function _tryAddUser(name) {
        if (name == undefined || this.userList.includes(name)) {
            return
        }
        console.log("add user " + name)
        this.userList.push(name)
    },
    nameExists: function _checkUser(name) {

        return this.userList.indexOf(name) > -1;
    },
    removeUser: function _removeUser(name) {
        var idx = this.userList.indexOf(name)
        if (idx > -1) {
            console.log("remove user " + name)
            this.userList.splice(idx, 1)
        }
    }
}

module.exports = new Utils();