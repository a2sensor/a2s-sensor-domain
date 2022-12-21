#!/usr/bin/env dry-wit
# (c) 2022-today A2Sensor
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
# mod: a2s-sensor-domain/mongodb/Sensor_02-additionalPermissions
# api: public
# txt: Grants read/write permissions to Sensor user in a local MongoDB server.

DW.import mongodb
DW.import step

# fun: main
# api: public
# txt: Grants read/write permissions to Sensor user in a local MongoDB server.
# txt: Returns 0/TRUE always.
# use: main;
function main() {
  grant_Sensor_roles
}

# fun: add_Sensor_roles
# api: public
# txt: Adds the Sensor roles.
# txt: Returns 0/TRUE always, but can exit if the role cannot be added.
# use: add_Sensor_roles;
function grant_Sensor_roles() {
  grant_readWrite_role
}

# fun: grant_readWrite_role
# api: public
# txt: Grants the readWrite role.
# txt: Returns 0/TRUE always, but can exit if the role cannot be granted.
# use: grant_readWrite_role;
function grant_readWrite_role() {
  if ! isStepAlreadyDone GRANT_READWRITE_ROLE; then

    logDebug -n "Granting readWrite role to ${SENSOR_USER}"
    if grantMongodbRolesToUser \
      "${SENSOR_USER}" \
      "[ 'readWrite' ]" \
      "${SENSOR_DATABASE}" \
      "${ADMIN_USER_NAME}" \
      "${ADMIN_USER_PASSWORD}" \
      "${AUTHENTICATION_DATABASE}" \
      "${AUTHENTICATION_MECHANISM}"; then
      logDebugResult SUCCESS "done"
    else
      local _error="${ERROR}"
      logInfoResult FAILURE "failed"
      exitWithErrorCode CANNOT_GRANT_READWRITE_ROLE
      if ! isEmpty "${_error}"; then
        logDebug "${_error}"
      fi
    fi

    markStepAsAlreadyDone GRANT_READWRITE_ROLE
  fi
}

# Script metadata
setScriptDescription "Grants read/write permissions to Sensor user in a local MongoDB server."

# env: SENSOR_DATABASE: The name of the database used by Sensor. Defaults to "sensor".
defineEnvVar SENSOR_DATABASE OPTIONAL "The name of the database used by Sensor" "Sensor";
# env: AUTHENTICATION_DATABASE: The authentication database. Defaults to "admin".
defineEnvVar AUTHENTICATION_DATABASE MANDATORY "The authentication database" "admin"
# env: AUTHENTICATION_MECHANISM: The authentication mechanism. Defaults to SCRAM-SHA-1.
defineEnvVar AUTHENTICATION_MECHANISM MANDATORY "The authentication mechanism" "SCRAM-SHA-1"
# env: ADMIN_USER_NAME: The MongoDB admin user. Defaults to "admin".
defineEnvVar ADMIN_USER_NAME MANDATORY "The MongoDB admin user" "admin"
# env: ENABLE_FREE_MONITORING: Whether to enable the free monitoring feature. Defaults to true.
defineEnvVar ENABLE_FREE_MONITORING MANDATORY "Whether to enable the free monitoring feature" true
# env: SENSOR_USER: The Sensor user in MongoDB. Defaults to "sensor".
defineEnvVar SENSOR_USER OPTIONAL "The Sensor user in MongoDB" "sensor";

addError CANNOT_GRANT_READWRITE_ROLE "Cannot add the readWrite role to ${SENSOR_USER}";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
