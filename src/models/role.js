const knex = require('../db');

const TABLE = 'Role';

async function getAll() {
    return knex(TABLE).select('RoleID', 'Name');
}

async function getById(roleId) {
    return knex(TABLE).where('RoleID', roleId).first();
}

module.exports = {
    getAll,
    getById
};  