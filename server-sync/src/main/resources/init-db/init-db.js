db.createUser({
  user: "usr",
  pwd: "1qaz2wsx",
  roles: [ {role: "readWrite", db: "notes"} ]
})