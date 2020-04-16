#include <stdio.h>
#include <sicm_low.h>

sicm_device_list devs;

int main() {
	int i;
	sicm_arena s;
	char *buf1, *buf2;

	devs = sicm_init();
	for(i = 0; i < devs.count; i++) {
		sicm_device *dev;

		dev = &devs.devices[i];
		printf("tag %s %d numa %d pagesize %d\n", sicm_device_tag_str(dev->tag), i, sicm_numa_id(dev), sicm_device_page_size(dev));
	}

	sicm_device *dev = sicm_find_device(&devs, SICM_OPTANE, 4, NULL);
	printf("dev %p\n", dev);

	s = sicm_arena_create(0, dev);
	if (s == NULL) {
		fprintf(stderr, "sicm_arena_create failed\n");
		return -1;
	}

	buf1 = sicm_arena_alloc(s, 1024);
	buf2 = sicm_arena_alloc(s, 2048*1024);
	sicm_free(buf1);
	sicm_free(buf2);
	return 0;
}
