PROGRAMS += ssss-split ssss-combine

all: $(PROGRAMS) ssss.1 ssss.1.html

CC = gcc

CFLAGS = \
	-std=c99 \
	-W \
	-Wall \
	-Wextra \
	-O3 \
	-Wp,-MMD,$(dir $@).$(notdir $@).d \
	-Wp,-MT,$@ \
	-D_GNU_SOURCE \

ifdef 0
MBEDTLS_DIR = ../mbedtls-2.3.0
CFLAGS += \
	-DCONFIG_MBEDTLS \
	-I$(MBEDTLS_DIR)/include \

LDFLAGS += \
	-L$(MBEDTLS_DIR)/library \
	-lmbedtls \

else
LDFLAGS += -lgmp
endif

ssss-split: ssss.o
	$(CC) -o $@ $^ $(LDFLAGS)

ssss-combine: ssss-split
	ln -f ssss-split ssss-combine

ssss.1: ssss.manpage.xml
	xmltoman ssss.manpage.xml > ssss.1

ssss.1.html: ssss.manpage.xml
	xmlmantohtml ssss.manpage.xml > ssss.1.html

clean:
	rm -rf $(PROGRAMS) ssss.1 ssss.1.html *.o

-include .*.o.d
