const knex = require('../src/db'); 
const roleModel = require('../src/models/role');

describe('Role model', () => {
  let trx;
  beforeEach(async () => {
    trx = await knex.transaction();
  });
  afterEach(async () => {
    await trx.rollback();
  });

  test('getAll() returns seeded roles', async () => {
    const roles = await roleModel.getAll();
    expect(roles.length).toBeGreaterThan(0);
    expect(roles.map(r => r.Name)).toContain('Engineer');
    expect(roles.map(r => r.Name)).toContain('Scientist');
    expect(roles.map(r => r.Name)).toContain('Technician');
    expect(roles.map(r => r.Name)).toContain('Administrator');
  });

  test('getById() returns correct role', async () => {
    const engineer = await knex('Role').where({ Name: 'Engineer' }).first();
    expect(engineer).toBeTruthy();

    const fetched = await roleModel.getById(engineer.RoleID);
    expect(fetched).toMatchObject({
      RoleID: engineer.RoleID,
      Name: 'Engineer',
    });
  });
});
