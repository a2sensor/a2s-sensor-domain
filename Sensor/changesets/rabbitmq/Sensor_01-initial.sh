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
# mod: a2s-sensor-domain/rabbitmq/Sensor_01-initial
# api: public
# txt: Creates user, queues, exchanges, etc, required by A2S Sensor Domain.

DW.import rabbitmq;

# fun: main
# api: public
# txt: Creates user, queues, exchanges, etc, required by A2S Sensor Domain.
# txt: Returns 0/TRUE always, but can exit in case of error.
# use: main
function main() {
  logDebug -n "Adding the user";
  if add_user_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_ADD_THE_USER;
  fi;

  if isNotEmpty "${SENSOR_TAGS}"; then
    logDebug -n "Adding the tags of ${SENSOR_USER}";
    if add_user_tags "${ADMIN_USER}" "${ADMIN_PASSWORD}"; then
      logDebugResult SUCCESS "done";
    else
      logDebugResult FAILURE "failed";
      logDebug "${ERROR}";
      exitWithErrorCode CANNOT_SET_THE_TAGS;
    fi
  fi

  logDebug -n "Configuring the permissions";
  if set_user_permissions; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_SET_THE_PERMISSIONS;
  fi

  logDebug -n "Declaring the exchanges";
  if declare_exchanges_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_EXCHANGES;
  fi

  logDebug -n "Declaring the dead-letter exchanges";
  if declare_deadletter_exchanges_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_DEADLETTER_EXCHANGES;
  fi

  logDebug -n "Declaring the queues";
  if declare_queues_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_QUEUES;
  fi

  logDebug -n "Declaring the dead-letter queues";
  if declare_deadletter_queues_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_DEADLETTER_QUEUES;
  fi

  logDebug -n "Declaring the audit queues";
  if declare_audit_queues_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_AUDIT_QUEUES;
  fi

  logDebug -n "Declaring the dead-letter bindings";
  if declare_deadletter_bindings_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_DEADLETTER_BINDINGS;
  fi

  logDebug -n "Declaring the audit bindings";
  if declare_audit_bindings_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_DECLARE_THE_AUDIT_BINDINGS;
  fi

  logDebug -n "Setting the policies";
  if set_policies_if_necessary; then
    logDebugResult SUCCESS "done";
  else
    logDebugResult FAILURE "failed";
    logDebug "${ERROR}";
    exitWithErrorCode CANNOT_SET_THE_POLICIES;
  fi
}

# fun: add_user_if_necessary
# api: public
# txt: Adds the user, if necessary.
# txt: Returns 0/TRUE if the user gets created successfully, or it already existed; 1/FALSE otherwise.
# use: if add_user_if_necessary; then
# use:   echo "User created successfully, or it already existed";
# use: fi
function add_user_if_necessary() {
  if ! userAlreadyExists "${SENSOR_USER}" "${RABBITMQ_NODENAME}"; then
    addUser "${SENSOR_USER}" "${SENSOR_PASSWORD}" "${RABBITMQ_NODENAME}";
  fi
}

# fun: add_user_tags acessUser accessPassword
# api: public
# txt: Adds some tags for the Sensor user.
# opt: accessUser: The user used to connect to the RabbitMQ instance. Optional.
# opt: accessPassword: The credentials of accessUser. Optional.
# txt: Returns 0/TRUE if the tags are added successfully; 1/FALSE otherwise.
# use: if add_user_tags admin 'secret'; then
# use:   echo "Tags added successfully";
# use: fi
function add_user_tags() {
  local _accessUser="${1}";
  local _accessPassword="${2}";

  local _oldIFS="${IFS}";
  local _tag;
  IFS="${DWIFS}";
  for _tag in ${SENSOR_TAGS}; do
    IFS="${_oldIFS}";
    addTagToUser "${SENSOR_USER}" "${_tag}" "${RABBITMQ_NODENAME}" "${_accessUser}" "${_accessPassword}";
  done;
  IFS="${_oldIFS}";
}

# fun: set_user_permissions
# api: public
# txt: Sets the user permissions.
# txt: Returns 0/TRUE if the permissions are set successfully; 1/FALSE otherwise.
# use: if set_user_permissions; then
# use:   echo "User permissions set successfully";
# use: fi
function set_user_permissions() {
  # TODO: FIX THE VIRTUALHOST
  setPermissions / "${SENSOR_USER}" "${SENSOR_CONFIGURE_PERMISSIONS}" "${SENSOR_WRITE_PERMISSIONS}" "${SENSOR_READ_PERMISSIONS}" "${RABBITMQ_NODENAME}";
}

# fun: declare_exchanges_if_necessary
# api: public
# txt: Declares the exchanges, if necessary.
# txt: Returns 0/TRUE if the exchange get created successfully, or already existed; 1/FALSE otherwise.
# use: if declare_exchanges_if_necessary; then
# use:   echo "Exchanges created successfully";
# use: fi
function declare_exchanges_if_necessary() {
  if ! exchangeAlreadyExists "${SENSOR_EXCHANGE_NAME}" "${SENSOR_EXCHANGE_TYPE}" "${RABBITMQ_NODENAME}"; then
    declareExchange "${SENSOR_EXCHANGE_NAME}" "${SENSOR_EXCHANGE_TYPE}" "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}" "${SENSOR_EXCHANGE_DURABLE}" "${SENSOR_EXCHANGE_INTERNAL}";
  fi
}

# fun: declare_deadletter_exchange_if_necessary
# api: public
# txt: Declares the dead-letter exchanges, if necessary.
# txt: Returns 0/TRUE if the dead-letter exchanges are declared successfully, or they already existed; 1/FALSE otherwise.
# use: if declare_deadletter_exchanges_if_necessary; then
# use:   echo "Dead-letter exchanges created successfully, or already existed";
# use: fi
function declare_deadletter_exchanges_if_necessary() {
  if ! exchangeAlreadyExists "${SENSOR_DLX_NAME}" "${SENSOR_DLX_TYPE}" "${RABBITMQ_NODENAME}"; then
    declareExchange "${SENSOR_DLX_NAME}" "${SENSOR_DLX_TYPE}" "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# fun: declare_queues_if_necessary
# api: public
# txt: Declares the queues, if necessary.
# txt: Returns 0/TRUE if the queues are declared successfully or already existed; 1/FALSE otherwise.
# use: if declare_queues_if_necessary; then
# use:   echo "Queues created successfully, or already existed";
# use: fi
function declare_queues_if_necessary() {
  if ! queueAlreadyExists "${SENSOR_QUEUE_NAME}" "${RABBITMQ_NODENAME}"; then
    declareQueue "${SENSOR_QUEUE_NAME}" ${SENSOR_QUEUE_DURABLE} "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# fun: declare_deadletter_queues_if_necessary
# api: public
# txt: Declares the dead-letter queues, if necessary.
# txt: Returns 0/TRUE if the dead-letter queues are declared successfully or they already existed; 1/FALSE otherwise..
# use: if declare_deadletter_queues_if_necessary; then
# use:   echo "Dead-letter queues created successfully, or already existed";
# use: fi
function declare_deadletter_queues_if_necessary() {
  if ! queueAlreadyExists "${SENSOR_DLQ_NAME}" "${RABBITMQ_NODENAME}"; then
    declareQueue "${SENSOR_DLQ_NAME}" ${SENSOR_DLQ_DURABLE} "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# fun: declare_audit_queues_if_necessary
# api: public
# txt: Declares the audit queues, if necessary.
# txt: Returns 0/TRUE if the audit queues are declared successfully, or already existed; 1/FALSE otherwise.
# use: if declare_audit_queues_if_necessary; then
# use:   echo "Audit queues created successfully, or already existed";
# use: fi
function declare_audit_queues_if_necessary() {
  if ! queueAlreadyExists "${SENSOR_AUDIT_TO_QUEUE_NAME}" "${RABBITMQ_NODENAME}"; then
    declareQueue "${SENSOR_AUDIT_TO_QUEUE_NAME}" ${SENSOR_AUDIT_TO_QUEUE_DURABLE} "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
  if ! queueAlreadyExists "${SENSOR_AUDIT_FROM_QUEUE_NAME}" "${RABBITMQ_NODENAME}"; then
    declareQueue "${SENSOR_AUDIT_FROM_QUEUE_NAME}" ${SENSOR_AUDIT_FROM_QUEUE_DURABLE} "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# fun: declare_deadletter_bindings_if_necessary
# api: public
# txt: Declares the dead-letter bindings, if necessary.
# txt: Returns 0/TRUE if the dead-letter bindings get created successfully, or already existed; 1/FALSE otherwise.
# use: if declare_deadletter_bindings_if_necessary; then
# use:   echo "Dead-letter bindings declared successfully, or already existed";
# use: fi
function declare_deadletter_bindings_if_necessary() {
  if ! bindingAlreadyExists "${SENSOR_DLX_NAME}" queue "${SENSOR_DLQ_NAME}" "#" "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}"; then
    declareBinding "${SENSOR_DLX_NAME}" queue "${SENSOR_DLQ_NAME}" "#" "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# fun: declare_audit_bindings_if_necessary
# api: public
# txt: Declares the audit bindings, if necessary.
# txt: Returns 0/TRUE if the audit bindings get created successfully, or already existed; 1/FALSE otherwise.
# use: if declare_audit_bindings_if_necessary; then
# use:   echo "Audit bindings declared successfully, or already existed";
# use: fi
function declare_audit_bindings_if_necessary() {
  if ! bindingAlreadyExists "${SENSOR_EXCHANGE_NAME}" queue "${SENSOR_AUDIT_FROM_QUEUE_NAME}" "#" "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}"; then
    declareBinding "${SENSOR_EXCHANGE_FROM_NAME}" queue "${SENSOR_AUDIT_FROM_QUEUE_NAME}" "#" "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# fun: set_policies_if_necessary
# api: public
# txt: Sets the policies, if necessary.
# txt: Returns 0/TRUE if the policies get created successfully, or they already existed; 1/FALSE otherwise.
# use: if set_policies_if_necessary; then
# use:   echo "Policies set successfully, or they already existed";
# use: fi
function set_policies_if_necessary() {
  if ! policyAlreadyExists "${SENSOR_DLX_NAME}" "^${SENSOR_QUEUE_NAME}$" "{\"dead-letter-exchange\":\"${SENSOR_DLX_NAME}\"}" queues "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}"; then
    setPolicy "${SENSOR_DLX_NAME}" "^${SENSOR_QUEUE_NAME}$" "{\"dead-letter-exchange\":\"${SENSOR_DLX_NAME}\"}" queues "${RABBITMQ_NODENAME}" "${ADMIN_USER}" "${ADMIN_PASSWORD}";
  fi
}

# Script metadata

setScriptDescription "Creates user, queues, exchanges, etc, required by A2S Sensor Domain.";

addError CANNOT_ADD_THE_USER "Cannot add the user";
addError CANNOT_SET_THE_TAGS "Cannot set the user tags";
addError CANNOT_SET_THE_PERMISSIONS "Cannot set the user permissions";
addError CANNOT_DECLARE_THE_EXCHANGES "Cannot declare the exchanges";
addError CANNOT_DECLARE_THE_DEADLETTER_EXCHANGES "Cannot declare the dead-letter exchanges";
addError CANNOT_DECLARE_THE_QUEUES "Cannot declare the queues";
addError CANNOT_DECLARE_THE_DEADLETTER_QUEUES "Cannot declare the dead-letter queues";
addError CANNOT_DECLARE_THE_AUDIT_QUEUES "Cannot declare the audit queues";
addError CANNOT_DECLARE_THE_BINDINGS "Cannot declare the bindings";
addError CANNOT_DECLARE_THE_DEADLETTER_BINDINGS "Cannot declare the dead-letter bindings";
addError CANNOT_DECLARE_THE_AUDIT_BINDINGS "Cannot declare the audit bindings";
addError CANNOT_SET_THE_POLICIES "Cannot set the policies";

# env: ADMIN_USER: The name of the admin user.
defineEnvVar ADMIN_USER MANDATORY "The name of the admin user" "admin";
# env: ADMIN_PASSWORD: The password of the admin user.
defineEnvVar ADMIN_PASSWORD MANDATORY "The password of the admin user";

# env: SENSOR: The name of the PharoEDA application.
defineEnvVar SENSOR MANDATORY "The name of the PharoEDA application" "Sensor"

# env: SENSOR_USER: The name of the user Sensor uses to connect.
defineEnvVar SENSOR_USER MANDATORY "The name of the user Sensor uses to connect" "sensor";
# env: SENSOR_PASSWORD: The password of the user the Sensor uses to connect.
defineEnvVar SENSOR_PASSWORD MANDATORY "The password of the user the Sensor uses to connect";
# env: SENSOR_TAGS: The tags of the user Sensor uses to connect.
defineEnvVar SENSOR_TAGS OPTIONAL "The tags of the Sensor user" "";
# env: SENSOR_CONFIGURE_PERMISSIONS: The configure permissions for the Sensor user.
defineEnvVar SENSOR_CONFIGURE_PERMISSIONS MANDATORY "The configure permissions for the Sensor user" ".*";
# env: SENSOR_WRITE_PERMISSIONS: The write permissions for the Sensor user.
defineEnvVar SENSOR_WRITE_PERMISSIONS MANDATORY "The write permissions for the Sensor user" ".*";
# env: SENSOR_READ_PERMISSIONS: The read permissions for the Sensor user.
defineEnvVar SENSOR_READ_PERMISSIONS MANDATORY "The read permissions for the Sensor user" ".*";
# env: SENSOR_QUEUE_NAME: The name of the queue Sensor reads from.
defineEnvVar SENSOR_QUEUE_NAME MANDATORY "The name of the queue Sensor reads from" "to-sensor";
# env: SENSOR_QUEUE_DURABLE: Whether the Sensor queue should be durable or not.
defineEnvVar SENSOR_QUEUE_DURABLE MANDATORY "Whether the Sensor queue should be durable or not" "true";
# env: SENSOR_DLQ_NAME: The name of the Sensor dead-letter queue.
defineEnvVar SENSOR_DLQ_NAME MANDATORY "The name of the Sensor dead-letter queue" "to-sensor-dlq";
# env: SENSOR_DLQ_DURABLE: Whether the Sensor dead-letter queue should be durable or not.
defineEnvVar SENSOR_DLQ_DURABLE MANDATORY "Whether the Sensor dead-letter queue should be durable or not" "true";
# env: SENSOR_AUDIT_TO_QUEUE_NAME: The name of the audit queue to Sensor.
defineEnvVar SENSOR_AUDIT_TO_QUEUE_NAME MANDATORY "The name of the audit queue to Sensor" "to-sensor@audit";
# env: SENSOR_AUDIT_QUEUE_TO_DURABLE: Whether the audit queue for incoming messages to Sensor should be durable or not.
defineEnvVar SENSOR_AUDIT_QUEUE_TO_DURABLE MANDATORY "Whether the audit queue for incoming messages to Sensor should be durable or not" "true";
# env: SENSOR_AUDIT_FROM_QUEUE_NAME: The name of the audit queue for messages from Sensor.
defineEnvVar SENSOR_AUDIT_FROM_QUEUE_NAME MANDATORY "The name of the audit queue for messages from Sensor" "to-sensor@audit";
# env: SENSOR_AUDIT_QUEUE_FROM_DURABLE: Whether the audit queue for outgoing messages from Sensor should be durable or not.
defineEnvVar SENSOR_AUDIT_QUEUE_FROM_DURABLE MANDATORY "Whether the audit queue for incoming messages from Sensor should be durable or not" "true";
# env: SENSOR_EXCHANGE_NAME: The name of the exchange Sensor writes to.
defineEnvVar SENSOR_EXCHANGE_NAME MANDATORY "The name of the exchange Sensor writes to" "from-sensor";
# env: SENSOR_EXCHANGE_TYPE: The type of the exchange Sensor writes to.
defineEnvVar SENSOR_EXCHANGE_TYPE MANDATORY "The type of the exchange Sensor writes to" "fanout";
# env: SENSOR_EXCHANGE_DURABLE: Whether the Sensor exchange is durable or not.
defineEnvVar SENSOR_EXCHANGE_DURABLE MANDATORY "Whether the Sensor exchange is durable or not" "true";
# env: SENSOR_EXCHANGE_INTERNAL: Whether the Sensor exchange is internal or not.
defineEnvVar SENSOR_EXCHANGE_INTERNAL MANDATORY "Whether the Sensor exchange is internal or not" "false";
# env: SENSOR_DLX_NAME: The name of the dead-letter exchange for Sensor.
defineEnvVar SENSOR_DLX_NAME MANDATORY "The name of the dead-letter exchange for Sensor" "from-sensor-dlx";
# env: SENSOR_DLX_TYPE: The type of the dead-letter exchange for Sensor.
defineEnvVar SENSOR_DLX_TYPE MANDATORY "The type of the dead-letter exchange for Sensor" "fanout";
# vim: syntax=sh ts=2 sw=2 sts=4 sr noet
