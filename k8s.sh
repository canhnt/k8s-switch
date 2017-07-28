#!/bin/bash

function set_iterm2_title() {
	TITLE=$1
	export PROMPT_COMMAND='echo -ne "\033]0;$TITLE\007"'
}

function set_iterm2_badge_vars() {
	echo "set badge $1 $2"
	iterm2_set_user_var k8sStackName $1
	iterm2_set_user_var k8sNamespace $2
	# set_iterm2_title $1
}

NAMESPACE=$2
case $1 in
	'dev')
		STACKNAME='development'
		;;
	'testing')
		STACKNAME='testing'
		;;
	'mon')
		STACKNAME='monitor'
		NAMESPACE='monitoring'
		;;
		echo "Invalid stack name:$1"
		return -1
		;;
esac
if [[ -z $NAMESPACE ]]; then
	NAMESPACE="ondemand2"
fi

STACKROOT="$OD2DOC/k8s/$STACKNAME.onehippo.io"
echo "Loading config for $STACKNAME stack, namespace $NAMESPACE at $STACKROOT"

export KUBECONFIG="$STACKROOT/kubeconfig"
export CONTEXT=$(kubectl config view | awk '/current-context/ {print $2}')
kubectl config set-context $CONTEXT --namespace=$NAMESPACE

set_iterm2_badge_vars $STACKNAME $NAMESPACE
ssh-add	"$STACKROOT/credentials/id_rsa"
