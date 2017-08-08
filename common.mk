.PHONY: stop-container
stop-container:
	docker stop $(CONTAINER_NAME)

.PHONY: kill-container
kill-container:
	-docker kill $(CONTAINER_NAME)

.PHONY: rm-container
rm-container: kill-container
	-docker rm $(CONTAINER_NAME)

# removes containers and deletes image (unsubscribing)
.PHONY: implode
implode: rm-container
	docker run --rm -it $(IMAGE_NAME) \
		subscription-manager remove --all
	docker rmi $(IMAGE_NAME)
