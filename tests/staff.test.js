const knex       = require('../src/db/index.js');
const roleModel  = require('../src/models/role');
const staffModel = require('../src/models/staff');

describe('Staff model', () => {
  let trx;
  let engineerRoleId;

  beforeAll(async () => {
    const roles = await roleModel.getAll();
    const engineer = roles.find(r => r.Name === 'Engineer');
    if (!engineer) {
      throw new Error('Seeded "Engineer" role not found');
    }
    engineerRoleId = engineer.RoleID;
  });

  beforeEach(async () => {
    trx = await knex.transaction();
  });

  afterEach(async () => {
    await trx.rollback();
  });

  afterAll(async () => {
    await knex.destroy();
  });

  test('create() and getByID()', async () => {
    const janeData = {
      firstName:  'Jane',
      lastName:   'Doe',
      email:      'jane.doe@example.com',
      dateHired:  '2025-01-01',
      roleID:     engineerRoleId,
      facilityID: null
    };
    const created = await staffModel.create(janeData, trx);
    expect(created).toMatchObject({
      FirstName:  'Jane',
      LastName:   'Doe',
      Email:      'jane.doe@example.com',
      RoleID:     engineerRoleId,
      FacilityID: null
    });

    const fetched = await staffModel.getByID(created.StaffID, trx);
    expect(fetched.Email).toBe('jane.doe@example.com');
  });

  test('getWithRole() returns RoleName', async () => {
    const data = {
      firstName:  'Jim',
      lastName:   'Beam',
      email:      'jim.beam@example.com',
      dateHired:  '2024-12-12',
      roleID:     engineerRoleId,
      facilityID: null
    };
    const created = await staffModel.create(data, trx);

    const withRole = await staffModel.getWithRole(created.StaffID, trx);
    expect(withRole).toHaveProperty('StaffID', created.StaffID);
    expect(withRole).toHaveProperty('RoleName', 'Engineer');
    expect(withRole.FirstName).toBe('Jim');
  });
});
