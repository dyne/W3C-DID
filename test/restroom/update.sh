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
echo "### UPDATE ###"
# admin
echo ""
echo "CREATE NEW ADMINS"
create_admin test-update-service-keyring.json
rm -f service-admin-did.json
# create an admin, spec admin, spec.ctx admin and spec.ctx to be updated later
create_admin test-update-2-service-keyring.json admin_original.json
tmp=`mktemp` && jq '.didDocument | del(.proof) | {"did_document": .}' admin_original.json > ${tmp} && mv ${tmp} admin_original.json

create_request  ${domain}_A-keyring.json \
                ${domain}_A \
                test-update-service-keyring.json \
                admin \
                ${tmpreq} \
                ${domain}_A_original.json
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                test-update-service-keyring.json \
                admin \
                ${tmpreq} \
                ${domain}.${ctx}_A_original.json
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                test-update-service-keyring.json \
                admin \
                ${tmpreq} \
                ${domain}.${ctx}_original.json
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  ${domain}-keyring.json \
                ${domain} \
                test-update-service-keyring.json \
                admin \
                ${tmpreq} \
                ${domain}_original.json
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

echo ""
echo "SIMULATE ALL THE UPDATE for ${domain} domain"
## Admin 
printf "%-18s %-20s %s\n" "admin" "does not update" "admin"
update_request  test_1 \
                admin_original.json \
                test-update-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "updates" "${domain}_A"
update_request  test_1 \
                ${domain}_A_original.json \
                test-update-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "updates" "${domain}.${ctx}_A"
update_request  test_1 \
                ${domain}.${ctx}_A_original.json \
                test-update-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "updates" "${domain}.${ctx}"
update_request  test_1 \
                ${domain}.${ctx}_original.json \
                test-update-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "updates" "${domain}"
update_request  test_1 \
                ${domain}_original.json \
                test-update-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 0
rm -f ${tmpreq}

## domain admin (domain_A)
printf "%-18s %-20s %s\n" "${domain}_A" "does not update" "admin"
update_request  test_2 \
                admin_original.json \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "does not update" "${domain}_A"
update_request  test_2 \
                ${domain}_A_original.json \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "updates" "${domain}.${ctx}_A"
update_request  test_2 \
                ${domain}.${ctx}_A_original.json \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "updates" "${domain}.${ctx}"
update_request  test_2 \
                ${domain}.${ctx}_original.json \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "updates" "${domain}"
update_request  test_2 \
                ${domain}_original.json \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 0
rm -f ${tmpreq}

## domain.context admin (domain.ctx_A)
printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not update" "admin"
update_request  test_3 \
                admin_original.json \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not update" "${domain}_A"
update_request  test_3 \
                ${domain}_A_original.json \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not update" "${domain}.${ctx}_A"
update_request  test_3 \
                ${domain}.${ctx}_A_original.json \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "updates" "${domain}.${ctx}"
update_request  test_3 \
                ${domain}.${ctx}_original.json \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not update" "${domain}"
update_request  test_3 \
                ${domain}_original.json \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

## domain.context (domain.ctx)
printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not update" "admin"
update_request  test_4 \
                admin_original.json \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not update" "${domain}_A"
update_request  test_4 \
                ${domain}_A_original.json \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not update" "${domain}.${ctx}_A"
update_request  test_4 \
                ${domain}.${ctx}_A_original.json \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not update" "${domain}.${ctx}"
update_request  test_4 \
                ${domain}.${ctx}_original.json \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not update" "${domain}"
update_request  test_4 \
                ${domain}_original.json \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

## domain (domain)
printf "%-18s %-20s %s\n" "${domain}" "does not update" "admin"
update_request  test_5 \
                admin_original.json \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "does not update" "${domain}_A"
update_request  test_5 \
                ${domain}_A_original.json \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "does not update" "${domain}.${ctx}_A"
update_request  test_5 \
                ${domain}.${ctx}_A_original.json \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "does not update" "${domain}.${ctx}"
update_request  test_5 \
                ${domain}.${ctx}_original.json \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}" "does not update" "${domain}"
update_request  test_5 \
                ${domain}_original.json \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

echo ""
echo "DOMAIN ADMIN does not update other domains did"
[ "${domain}" = "sandbox" ] && second_domain="ifacer" || second_domain="sandbox"

create_request  test_A-keyring.json \
                ${second_domain}_A \
                test-update-service-keyring.json \
                admin \
                ${tmpreq} \
                test_A_original.json
send_request ${second_domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  test.${ctx}_A-keyring.json \
                ${second_domain}.${ctx}_A \
                test-update-service-keyring.json \
                admin \
                ${tmpreq} \
                test.${ctx}_A_original.json
send_request ${second_domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  test.${ctx}-keyring.json \
                ${second_domain}.${ctx} \
                test-update-service-keyring.json \
                admin \
                ${tmpreq} \
                test.${ctx}_original.json
send_request ${second_domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

create_request  test-keyring.json \
                ${second_domain} \
                test-update-service-keyring.json \
                admin \
                ${tmpreq} \
                test_original.json
send_request ${second_domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "does not update" "${second_domain}_A"
update_request  test_1 \
                test_A_original.json \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${second_domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "does not update" "${second_domain}.${ctx}_A"
update_request  test_1 \
                test.${ctx}_A_original.json \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${second_domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "does not update" "${second_domain}.${ctx}"
update_request  test_1 \
                test.${ctx}_original.json \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${second_domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "${domain}_A" "does not update" "${second_domain}"
update_request  test_1 \
                test_original.json \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${second_domain}/pubkeys-update.chain ${tmpreq} 255
rm -f ${tmpreq}

rm secrets/test* secrets/${domain}* *_original.json