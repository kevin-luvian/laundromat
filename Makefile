export NOW=$(shell date +"%Y/%m/%d")

generate:
	@echo "${NOW} == GENERATING FILES"
	@flutter pub run build_runner build --delete-conflicting-outputs