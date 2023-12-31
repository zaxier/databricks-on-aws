FROM docker/dev-environments-default:stable-1

COPY .aws /root/.aws
# COPY .zshrc ~/.zshrc
COPY .databrickscfg /root/.databrickscfg
