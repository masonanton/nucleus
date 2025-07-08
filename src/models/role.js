const knex = require('../db');

const TABLE = 'Role';

async function getAll() {
    return knex(TABLE).select('RoleID', 'Name');
}

async function getById(roleId) {
    return knex(TABLE).where('RoleID', roleId).first();
}

async function create(name) {
    const [id] = await knex(TABLE).insert({ Name : name });
    return getById(id);
}

module.exports = {
    getAll,
    getById,
    create
};  