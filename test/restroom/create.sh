#!/bin/bash
source ./test/restroom/functions.sh

[ "$#" = "2" ] || {
    >&2 echo "$0 domain context"
	exit 1
}
domain=$1
ctx=$2
tmpreq=`mktemp`
echo "### CREATE ###"
echo "CREATE ADMIN"
create_admin test-service-keyring.json
rm -f service-admin-did.json

echo ""
echo "SIMULATE ALL THE CREATION for ${domain} domain"
## Admin 
printf "%-18s %-20s %s\n" "admin" "does not create" "admin"
create_request  admin-keyring.json \
                admin \
                test-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/admin-keyring.json

printf "%-18s %-20s %s\n" "admin" "creates" "${domain}_A"
create_request  ${domain}_A-keyring.json \
                ${domain}_A \
                test-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "creates" "${domain}.${ctx}_A"
create_request  ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                test-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "creates" "${domain}.${ctx}"
create_request  ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                test-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

printf "%-18s %-20s %s\n" "admin" "creates" "${domain}"
create_request  ${domain}-keyring.json \
                ${domain} \
                test-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq}

## domain admin (domain_A)
printf "%-18s %-20s %s\n" "${domain}_A" "does not create" "admin"
create_request  admin-keyring.json \
                admin \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/admin-keyring.json

printf "%-18s %-20s %s\n" "${domain}_A" "does not create" "${domain}_A"
create_request  spec-admin-keyring.json \
                ${domain}_A \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec-admin-keyring.json

printf "%-18s %-20s %s\n" "${domain}_A" "creates" "${domain}.${ctx}_A"
create_request  spec.ctx-admin-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec.ctx-admin-keyring.json

printf "%-18s %-20s %s\n" "${domain}_A" "creates" "${domain}.${ctx}"
create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec.ctx-keyring.json

printf "%-18s %-20s %s\n" "${domain}_A" "creates" "${domain}"
create_request  spec-keyring.json \
                ${domain} \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec-keyring.json

## domain.context admin (domain.ctx_A)
printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not create" "admin"
create_request  admin-keyring.json \
                admin \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/admin-keyring.json

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not create" "${domain}_A"
create_request  spec-admin-keyring.json \
                ${domain}_A \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec-admin-keyring.json

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not create" "${domain}.${ctx}_A"
create_request  spec.ctx-admin-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec.ctx-admin-keyring.json

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "creates" "${domain}.${ctx}"
create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 0
rm -f ${tmpreq} secrets/spec.ctx-keyring.json

printf "%-18s %-20s %s\n" "${domain}.${ctx}_A" "does not create" "${domain}"
create_request  spec-keyring.json \
                ${domain} \
                ${domain}.${ctx}_A-keyring.json \
                ${domain}.${ctx}_A \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec-keyring.json

## domain.context (domain.ctx)
printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not create" "admin"
create_request  admin-keyring.json \
                admin \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/admin-keyring.json

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not create" "${domain}_A"
create_request  spec-admin-keyring.json \
                ${domain}_A \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec-admin-keyring.json

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not create" "${domain}.${ctx}_A"
create_request  spec.ctx-admin-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec.ctx-admin-keyring.json

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not create" "${domain}.${ctx}"
create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec.ctx-keyring.json

printf "%-18s %-20s %s\n" "${domain}.${ctx}" "does not create" "${domain}"
create_request  spec-keyring.json \
                ${domain} \
                ${domain}.${ctx}-keyring.json \
                ${domain}.${ctx} \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec-keyring.json

## domain (domain)
printf "%-18s %-20s %s\n" "${domain}" "does not create" "admin"
create_request  admin-keyring.json \
                admin \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/admin-keyring.json

printf "%-18s %-20s %s\n" "${domain}" "does not create" "${domain}_A"
create_request  spec-admin-keyring.json \
                ${domain}_A \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec-admin-keyring.json

printf "%-18s %-20s %s\n" "${domain}" "does not create" "${domain}.${ctx}_A"
create_request  spec.ctx-admin-keyring.json \
                ${domain}.${ctx}_A \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec.ctx-admin-keyring.json

printf "%-18s %-20s %s\n" "${domain}" "does not create" "${domain}.${ctx}"
create_request  spec.ctx-keyring.json \
                ${domain}.${ctx} \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec.ctx-keyring.json

printf "%-18s %-20s %s\n" "${domain}" "does not create" "${domain}"
create_request  spec-keyring.json \
                ${domain} \
                ${domain}-keyring.json \
                ${domain} \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/spec-keyring.json

echo ""
echo "DOMAIN ADMIN does not creates other domains did"
[ "${domain}" = "sandbox" ] && second_domain="ifacer" || second_domain="sandbox" 

printf "%-18s %-20s %s\n" "${domain}_A" "does not create" "${second_domain}_A"
create_request  test-keyring.json \
                ${second_domain}_A \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${second_domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/test-keyring.json

printf "%-18s %-20s %s\n" "${domain}_A" "does not create" "${second_domain}.${ctx}_A"
create_request  test-keyring.json \
                ${second_domain}.${ctx}_A \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${second_domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/test-keyring.json

printf "%-18s %-20s %s\n" "${domain}_A" "does not create" "${second_domain}.${ctx}"
create_request  test-keyring.json \
                ${second_domain}.${ctx} \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${second_domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/test-keyring.json

printf "%-18s %-20s %s\n" "${domain}_A" "does not create" "${second_domain}"
create_request  test-keyring.json \
                ${second_domain} \
                ${domain}_A-keyring.json \
                ${domain}_A \
                ${tmpreq}
send_request ${second_domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq} secrets/test-keyring.json

rm -f secrets/${domain}*

echo ""
echo "TEST creation with multiple points and underscores"
# create a did with two points "."
printf "%-18s %-20s %s\n" "admin" "does not create" "admin_A"
create_request  ${domain}.${ctx}.fail-keyring.json \
                admin_A \
                test-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f secrets/${domain}.${ctx}.fail-keyring.json

printf "%-18s %-20s %s\n" "admin" "does not create" "${domain}.${ctx}.fail"
create_request  ${domain}.${ctx}.fail-keyring.json \
                ${domain}.${ctx}.fail \
                test-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f secrets/${domain}.${ctx}.fail-keyring.json

printf "%-18s %-20s %s\n" "admin" "does not create" "${domain}_A_A"
create_request  ${domain}.${ctx}.fail-keyring.json \
                ${domain}.${ctx}.fail \
                test-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f secrets/${domain}.${ctx}.fail-keyring.json

printf "%-18s %-20s %s\n" "admin" "does not create" "${domain}.${ctx}.fail_A"
create_request  ${domain}.${ctx}.fail-keyring.json \
                ${domain}.${ctx}.fail_A \
                test-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f secrets/${domain}.${ctx}.fail-keyring.json

printf "%-18s %-20s %s\n" "admin" "does not create" "${domain}_A.fail"
create_request  ${domain}.${ctx}.fail-keyring.json \
                ${domain}.${ctx}.fail \
                test-service-keyring.json \
                admin \
                ${tmpreq}
send_request ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f secrets/${domain}.${ctx}.fail-keyring.json did_doc.json