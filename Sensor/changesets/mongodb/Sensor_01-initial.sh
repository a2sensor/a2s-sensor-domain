#!/usr/bin/env dry-wit
# (c) 2022-today A2Sensor.
#
#    This file is part of a2s-sensor-domain.
#
#    a2s-sensor-domain is free software: you can redistribute it and/or
#    modify it under the terms of the GNU General Public License as published
#    by the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    a2s-sensor-domain is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with a2s-sensor-domain.
#    If not, see <http://www.gnu.org/licenses/>.
#
# mod: a2s-sensor-domain/mongodb/Sensor_01-initial
# api: public
# txt: Prepares a local MongoDB server for A2S sensor domain.

DW.import mongodb
DW.import step

# fun: main
# api: public
# txt: Prepares a local MongoDB server for A2S sensor domain.
# txt: Returns 0/TRUE always.
# use: main;
function main() {
  add_Sensor_roles;

  add_Sensor_user;

  add_indexes;
}

# fun: add_Sensor_roles
# api: public
# txt: Adds the Sensor roles.
# txt: Returns 0/TRUE always, but can exit if the role cannot be added.
# use: add_Sensor_roles;
function add_Sensor_roles() {
  add_Sensor_find_role;
  add_Sensor_insert_role;
}

# fun: add_Sensor_find_role
# api: public
# txt: Adds the Sensor role.
# txt: Returns 0/TRUE always, but can exit if the role cannot be added.
# use: add_Sensor_find_role;
function add_Sensor_find_role() {
  if ! isStepAlreadyDone ADD_SENSORFIND_ROLE; then

    addMongodbRoleIfNecessary \
      "${SENSORFIND_ROLE}" \
      "[ { resource: { db: '${SENSOR_DATABASE}', collection: '${SENSOR_COLLECTION}' }, actions: [ 'find'  ] } ]" \
      '[]' \
      CANNOT_ADD_SENSORFIND_ROLE \
      SENSORFIND_ROLE_DOES_NOT_EXIST \
      "${SENSOR_DATABASE}" \
      "${ADMIN_USER_NAME}" \
      "${ADMIN_USER_PASSWORD}" \
      "${AUTHENTICATION_DATABASE}" \
      "${AUTHENTICATION_MECHANISM}"

    markStepAsAlreadyDone ADD_SENSORFIND_ROLE
  fi
}

# fun: add_Sensor_insert_role
# api: public
# txt: Adds the Sensor insert role.
# txt: Returns 0/TRUE always, but can exit if the role cannot be added.
# use: add_Sensor_insert_role;
function add_Sensor_insert_role() {
  if ! isStepAlreadyDone ADD_SENSORINSERT_ROLE; then

    addMongodbRoleIfNecessary \
      "${SENSORINSERT_ROLE}" \
      "[ { resource: { db: '${SENSOR_DATABASE}', collection: '${SENSOR_COLLECTION}' }, actions: [ 'insert' ] } ]" \
      '[]' \
      CANNOT_ADD_SENSORINSERT_ROLE \
      SENSORINSERT_ROLE_DOES_NOT_EXIST \
      "${SENSOR_DATABASE}" \
      "${ADMIN_USER_NAME}" \
      "${ADMIN_USER_PASSWORD}" \
      "${AUTHENTICATION_DATABASE}" \
      "${AUTHENTICATION_MECHANISM}"

    markStepAsAlreadyDone ADD_SENSORINSERT_ROLE
  fi
}

# fun: add_Sensor_user
# api: public
# txt: Adds the Sensor user.
# txt: Returns 0/TRUE always, but can exit if the Sensor user cannot be added.
# use: add_Sensor_user;
function add_Sensor_user() {
  if ! isStepAlreadyDone ADD_SENSOR_USER; then

    addMongodbUserIfNecessary \
      "${SENSOR_USER}" \
      "${SENSOR_PASSWORD}" \
      "${SENSOR_DATABASE}" \
      "[ { role: '${SENSORFIND_ROLE}', db: '${SENSOR_DATABASE}' },{ role: '${SENSORINSERT_ROLE}', db: '${SENSOR_DATABASE}' } ]" \
      CANNOT_ADD_SENSOR_USER \
      SENSOR_USER_CANNOT_LOG_IN \
      "${ADMIN_USER_NAME}" \
      "${ADMIN_USER_PASSWORD}" \
      "${AUTHENTICATION_DATABASE}" \
      "${AUTHENTICATION_MECHANISM}"

    markStepAsAlreadyDone ADD_SENSOR_USER;
  fi
}

# fun: add_indexes
# api: public
# txt: Creates the indexes.
# txt: Returns 0/TRUE always, but can exit if the any index cannot be created.
# use: add_indexes;
function add_indexes() {
  add_Sensor_indexes;
}

# fun: add_Sensor_indexes
# api: public
# txt: Creates the indexes on the Sensor collection.
# txt: Returns 0/TRUE always, but cat exit if any index cannot be created.
# use: add_Sensor_indexes;
function add_Sensor_indexes() {
  add_Sensor_Id_index;
  add_Sensor_Timestamp_index;
}

# fun: add_Sensor_Id_index
# api: public
# txt: Creates the Id index on the Sensor collection.
# txt: Returns 0/TRUE always, but cat exit if the index cannot be created.
# use: add_Sensor_Id_index;
function add_Sensor_Id_index() {
  if ! isStepAlreadyDone CREATE_SENSOR_ID_INDEX; then

    addMongodbIndexIfNecessary \
      "id" \
      "unique: true" \
      "${SENSOR_DATABASE}" \
      "${SENSOR_COLLECTION}" \
      CANNOT_CREATE_SENSOR_ID_INDEX \
      SENSOR_ID_INDEX_DOES_NOT_EXIST \
      "${ADMIN_USER_NAME}" \
      "${ADMIN_USER_PASSWORD}" \
      "${AUTHENTICATION_DATABASE}" \
      "${AUTHENTICATION_MECHANISM}";

    markStepAsAlreadyDone CREATE_SENSOR_ID_INDEX;
  fi
}

# fun: add_Sensor_Timestamp_index
# api: public
# txt: Creates the Timestamp index on the Sensor collection.
# txt: Returns 0/TRUE always, but cat exit if the index cannot be created.
# use: add_Sensor_Timestamp_index;
function add_Sensor_Timestamp_index() {
  if ! isStepAlreadyDone CREATE_SENSOR_TIMESTAMP_INDEX; then

    addMongodbIndexIfNecessary \
      "timestamp" \
      "unique: false" \
      "${SENSOR_DATABASE}" \
      "${SENSOR_COLLECTION}" \
      CANNOT_CREATE_SENSOR_TIMESTAMP_INDEX \
      SENSOR_TIMESTAMP_INDEX_DOES_NOT_EXIST \
      "${ADMIN_USER_NAME}" \
      "${ADMIN_USER_PASSWORD}" \
      "${AUTHENTICATION_DATABASE}" \
      "${AUTHENTICATION_MECHANISM}";

    markStepAsAlreadyDone CREATE_SENSOR_TIMESTAMP_INDEX;
  fi
}

# Script metadata
setScriptDescription "Prepares a local MongoDB server for A2S sensor domain."

# env: AUTHENTICATION_DATABASE: The authentication database. Defaults to "admin".
defineEnvVar AUTHENTICATION_DATABASE MANDATORY "The authentication database" "admin"
# env: AUTHENTICATION_MECHANISM: The authentication mechanism. Defaults to SCRAM-SHA-256.
defineEnvVar AUTHENTICATION_MECHANISM MANDATORY "The authentication mechanism" "SCRAM-SHA-1"
# env: ADMIN_USER_NAME: The MongoDB admin user. Defaults to "admin".
defineEnvVar ADMIN_USER_NAME MANDATORY "The MongoDB admin user" "admin"
# env: SENSOR_USER: The Sensor user in MongoDB. Defaults to "sensor".
defineEnvVar SENSOR_USER OPTIONAL "The Sensor user in MongoDB" "sensor";
# env: SENSOR_PASSWORD: The password of the Sensor user.
defineEnvVar SENSOR_PASSWORD MANDATORY "The password of the Sensor user";
# env: SENSOR_DATABASE: The name of the database used by Sensor. Defaults to "sensor".
defineEnvVar SENSOR_DATABASE OPTIONAL "The name of the database used by Sensor" "sensor";
# env: SENSOR_COLLECTION: The Sensor collection in Sensor database.
defineEnvVar SENSOR_COLLECTION OPTIONAL "The Sensor collection in Sensor database" 'Sensor';
# env: SENSORFIND_ROLE: The role to view the Sensor collection in Sensor database.
defineEnvVar SENSORFIND_ROLE OPTIONAL "The role to view the Sensor collection in Sensor database" "${SENSOR_COLLECTION}Find";
# env: SENSORINSERT_ROLE: The role to insert documents in the Sensor collection in Sensor database.
defineEnvVar SENSORINSERT_ROLE OPTIONAL "The role to insert documents in the Sensor collection in Sensor database" "${SENSOR_COLLECTION}Insert";

addError CANNOT_ADD_SENSORFIND_ROLE "Cannot add the ${SENSORFIND_ROLE} role";
addError SENSORFIND_ROLE_DOES_NOT_EXIST "${SENSORFIND_ROLE} role does not exist";
addError CANNOT_ADD_SENSORINSERT_ROLE "Cannot add the ${SENSORINSERT_ROLE} role";
addError SENSORINSERT_ROLE_DOES_NOT_EXIST "${SENSORINSERT} role does not exist";
addError CANNOT_ADD_SENSOR_USER "Cannot add the ${SENSOR_USER} user";
addError SENSOR_USER_CANNOT_LOG_IN "${SENSOR_USER} user cannot log in";
addError CANNOT_CREATE_SENSOR_ID_INDEX "Cannot create an index on 'id' in ${SENSOR_COLLECTION}";
addError SENSOR_ID_INDEX_DOES_NOT_EXIST "The index on attribute 'id' on ${SENSOR_COLLECTION} does not exist";
addError CANNOT_CREATE_SENSOR_TIMESTAMP_INDEX "Cannot create an index on 'timestamp' in ${SENSOR_COLLECTION}";
addError SENSOR_TIMESTAMP_INDEX_DOES_NOT_EXIST "The index on attribute 'timestamp' on ${SENSOR_COLLECTION} does not exist";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
