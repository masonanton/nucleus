const knex = require('../db');

const TABLE = 'Staff';

async function getAll() {
    return knex(TABLE).select('StaffID', 'FirstName', 'LastName', 'Email', 'DateHired', 'RoleID', 'FacilityID');
}

async function getByID(id) {
    return knex(TABLE).where({ 'StaffID': id }).first();
}

async function create({ firstName, lastName, email, dateHired, roleID, facilityID=null }) {
    const [StaffID] = await knex(TABLE).insert({
        FirstName: firstName,
        LastName: lastName,
        Email: email,
        DateHired: dateHired,
        RoleID: roleID,
        FacilityID: facilityID
    });
    return getByID(StaffID);
}

async function getWithRole(staffID) {
    return knex('Staff as s')
        .join('Role as r', 's.RoleID', 'r.RoleID')
        .select(
            's.StaffID','s.FirstName','s.LastName','s.Email','r.Name as RoleName'
        )
        .where('s.StaffID', staffID)
        .first();
}

module.exports = { 
    getAll,
    getByID,
    create,
    getWithRole
}