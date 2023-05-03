#!/bin/bash
source ./test/restroom/functions.sh

[ "$#" = "2" ] || {
    >&2 echo "$0 domain context"
	exit 1
}
domain=$1
ctx=$2
tmpreq=`mktemp`

echo ""
echo "### DELETE ###"
# admin
echo ""
echo "CREATE NEW ADMINS"
# all the levels that will try to deactivate other dids
create_admin test-delete-service-keyring.json

create_request  ${domain}_A-keyring.json \
                ${domain}_A \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  ${domain}-keyring.json \
                ${domain} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

# create an admin delete later
create_admin test-delete-2-service-keyring.json
rm -f service-admin-did.json
echo ""
echo "SIMULATE ALL THE DELETE for ${domain} domain"
## Admin
# create did docs to be delete from admin
create_request  spec_A-keyring.json \
                ${domain}_A \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq} \
                ${domain}.${ctx}_original.json
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec-keyring.json \
                ${domain} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "does not delete" "admin"
delete_request  test-delete-2-service-keyring.json \
                admin \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "deletes" "${domain}_A"
delete_request  spec_A-keyring.json \
                ${domain}_A \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec_A-keyring.json

printf "%-18s %-20s %s\n" "admin" "deletes" "${domain}.${ctx}_A"
delete_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec.ctx_A-keyring.json

printf "%-18s %-20s %s\n" "admin" "deletes" "${domain}.${ctx}"
delete_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec.ctx-keyring.json

printf "%-18s %-20s %s\n" "admin" "deletes" "${domain}"
delete_request  spec-keyring.json \
                ${domain} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec-keyring.json

## domain admin (domain_A)
# create did docs to be delete from domain admin
create_request  spec_A-keyring.json \
                ${domain}_A \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec-keyring.json \
                ${domain} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "does not delete" "admin"
delete_request  test-delete-2-service-keyring.json \
                admin \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "does not delete" "${domain}_A"
delete_request  spec_A-keyring.json \
                ${domain}_A \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "deletes" "${domain}.${ctx}_A"
delete_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec.ctx_A-keyring.json

printf "%-18s %-20s %s\n" "${domain}_A" "deletes" "${domain}.${ctx}"
delete_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec.ctx-keyring.json

printf "%-18s %-20s %s\n" "${domain}_A" "deletes" "${domain}"
delete_request  spec-keyring.json \
                ${domain} \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec-keyring.json

## domain.context admin (domain.ctx_A)
# create did docs to be delete from domain context admin
# (spec admin is still active so no need to create a new one)
create_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  spec-keyring.json \
                ${domain} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not delete" "admin"
delete_request  test-delete-2-service-keyring.json \
                admin \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not delete" "${domain}_A"
delete_request  spec_A-keyring.json \
                ${domain}_A \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not delete" "${domain}.${ctx}_A"
delete_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "deletes" "${domain}.${ctx}"
delete_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec.ctx-keyring.json

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not delete" "${domain}"
delete_request  spec-keyring.json \
                ${domain} \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

## domain.context (domain.ctx)
# create did docs to be delete from domain context
create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq} \
                ${domain}.${ctx}_original.json
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not delete" "admin"
delete_request  test-delete-2-service-keyring.json \
                admin \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not delete" "${domain}_A"
delete_request  spec_A-keyring.json \
                ${domain}_A \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not delete" "${domain}.${ctx}_A"
delete_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not delete" "${domain}.${ctx}"
delete_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not delete" "${domain}"
delete_request  spec-keyring.json \
                ${domain} \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

## domain (domain)
printf "%-18s %-20s %s\n" "${domain}" "does not delete" "admin"
delete_request  test-delete-2-service-keyring.json \
                admin \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "does not delete" "${domain}_A"
delete_request  spec_A-keyring.json \
                ${domain}_A \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "does not delete" "${domain}.${ctx}_A"
delete_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "does not delete" "${domain}.${ctx}"
delete_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "does not delete" "${domain}"
delete_request  spec-keyring.json \
                ${domain} \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

echo ""
echo "SELF REVOCATION"
printf "%-18s %-20s %s\n" "${domain}_A" "deletes" "itself"
delete_request  spec_A-keyring.json \
                ${domain}_A \
                spec_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec_A-keyring.json

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "deletes" "itself"
delete_request  spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                spec.ctx_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec.ctx_A-keyring.json

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "deletes" "itself"
delete_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "deletes" "itself"
delete_request  spec-keyring.json \
                ${domain} \
                spec-keyring.json \
                ${domain}\
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec-keyring.json

echo ""
echo "DOMAIN ADMIN does not delete other domains did"
[ "${domain}" = "sandbox" ] && second_domain="ifacer" || second_domain="sandbox" 

create_request  test_A-keyring.json \
                ${second_domain}_A \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${second_domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  test.${ctx}_A-keyring.json \
                ${second_domain}.${ctx}_A \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${second_domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  test.${ctx}-keyring.json \
                ${second_domain}.${ctx} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${second_domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  test-keyring.json \
                ${second_domain} \
                test-delete-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${second_domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "does not delete" "${second_domain}_A"
delete_request  test_A-keyring.json \
                ${second_domain}_A \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${second_domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq} 

printf "%-18s %-20s %s\n" "${domain}_A" "does not delete" "${second_domain}.${ctx}_A"
delete_request  test.${ctx}_A-keyring.json \
                ${second_domain}.${ctx}_A \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${second_domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "does not delete" "${second_domain}.${ctx}"
delete_request  test.${ctx}-keyring.json \
                ${second_domain}.${ctx} \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${second_domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "does not delete" "${second_domain}"
delete_request  test-keyring.json \
                ${second_domain} \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${second_domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

echo ""
echo "OTHER TESTS"
echo "did documents can not be deleted two times"
delete_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec.ctx-keyring.json

echo "deactivated dids can not create another did"
delete_request  ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 0
create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec.ctx-keyring.json

echo "deactivated dids can not update another did"
update_request  test_deactivation \
                ${domain}.${ctx}_original.json \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq} sandbox.test_original.json

echo "deactivated dids can not delete another did"
rm -f ${tmpreq}
delete_request  ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-deactivate.chain ${tmpreq} 255
rm -f ${tmpreq}

# cleanup secrets
rm -f secrets/test* \
   secrets/${domain}_A-keyring.json \
   secrets/${domain}.${ctx}_A-keyring.json \
   secrets/${domain}.${ctx}-keyring.json \
   secrets/${domain}-keyring.json \
   did_doc.json
