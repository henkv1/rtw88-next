# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
SHELL := /bin/sh
KVER ?= $(if $(KERNELRELEASE),$(KERNELRELEASE),$(shell uname -r))
KSRC ?= $(if $(KERNEL_SRC),$(KERNEL_SRC),/lib/modules/$(KVER)/build)
FIRMWAREDIR := /lib/firmware/rtw88
MODLIST := rtw_8723cs rtw_8723de rtw_8723ds rtw_8723du \
	   rtw_8812au rtw_8821au rtw_8821ce rtw_8821cs rtw_8821cu \
	   rtw_8822be rtw_8822bs rtw_8822bu rtw_8822ce rtw_8822cs rtw_8822cu \
	   rtw_8703b rtw_8723d rtw_8821a rtw_8812a rtw_8821c rtw_8822b rtw_8822c \
	   rtw_8723x rtw_88xxa rtw_pci rtw_sdio rtw_usb rtw_core
# Handle the move of the entire rtw88 tree
ifneq ("","$(wildcard /lib/modules/$(KVER)/kernel/drivers/net/wireless/realtek)")
MODDESTDIR := /lib/modules/$(KVER)/kernel/drivers/net/wireless/realtek/rtw88
else
MODDESTDIR := /lib/modules/$(KVER)/kernel/drivers/net/wireless/rtw88
endif

ifneq ("$(INSTALL_MOD_PATH)", "")
DEPMOD_ARGS = -b $(INSTALL_MOD_PATH)
else
DEPMOD_ARGS =
endif

#Handle the compression option for modules in 3.18+
ifneq ("","$(wildcard $(MODDESTDIR)/*.ko.gz)")
COMPRESS_GZIP := y
endif
ifneq ("","$(wildcard $(MODDESTDIR)/*.ko.xz)")
COMPRESS_XZ := y
endif
ifneq ("","$(wildcard $(MODDESTDIR)/*.ko.zst)")
COMPRESS_ZSTD := y
endif

ifeq ("","$(wildcard MOK.der)")
NO_SKIP_SIGN := y
endif

EXTRA_CFLAGS += -O2 -std=gnu11 -Wno-declaration-after-statement
ifeq ($(CONFIG_PCI), y)
EXTRA_CFLAGS += -DCONFIG_RTW88_8822BE=1
EXTRA_CFLAGS += -DCONFIG_RTW88_8821CE=1
EXTRA_CFLAGS += -DCONFIG_RTW88_8822CE=1
EXTRA_CFLAGS += -DCONFIG_RTW88_8723DE=1
endif
EXTRA_CFLAGS += -DCONFIG_RTW88_DEBUG=1
EXTRA_CFLAGS += -DCONFIG_RTW88_DEBUGFS=1
#EXTRA_CFLAGS += -DCONFIG_RTW88_REGD_USER_REG_HINTS

obj-$(CONFIG_RTW88_CORE)	+= rtw88_core.o
rtw88_core-y += main.o \
	   mac80211.o \
	   util.o \
	   debug.o \
	   tx.o \
	   rx.o \
	   mac.o \
	   phy.o \
	   coex.o \
	   efuse.o \
	   fw.o \
	   ps.o \
	   sec.o \
	   bf.o \
	   sar.o \
	   regd.o

rtw88_core-$(CONFIG_PM) += wow.o

rtw88_core-$(CONFIG_RTW88_LEDS) += led.o

obj-$(CONFIG_RTW88_8822B)	+= rtw88_8822b.o
rtw88_8822b-objs		:= rtw8822b.o rtw8822b_table.o

obj-$(CONFIG_RTW88_8822BE)	+= rtw88_8822be.o
rtw88_8822be-objs		:= rtw8822be.o

obj-$(CONFIG_RTW88_8822BS)	+= rtw88_8822bs.o
rtw88_8822bs-objs		:= rtw8822bs.o

obj-$(CONFIG_RTW88_8822BU)	+= rtw88_8822bu.o
rtw88_8822bu-objs		:= rtw8822bu.o

obj-$(CONFIG_RTW88_8822C)	+= rtw88_8822c.o
rtw88_8822c-objs		:= rtw8822c.o rtw8822c_table.o

obj-$(CONFIG_RTW88_8822CE)	+= rtw88_8822ce.o
rtw88_8822ce-objs		:= rtw8822ce.o

obj-$(CONFIG_RTW88_8822CS)	+= rtw88_8822cs.o
rtw88_8822cs-objs		:= rtw8822cs.o

obj-$(CONFIG_RTW88_8822CU)	+= rtw88_8822cu.o
rtw88_8822cu-objs		:= rtw8822cu.o

obj-$(CONFIG_RTW88_8723X)	+= rtw88_8723x.o
rtw88_8723x-objs		:= rtw8723x.o

obj-$(CONFIG_RTW88_8703B)	+= rtw88_8703b.o
rtw88_8703b-objs		:= rtw8703b.o rtw8703b_tables.o

obj-$(CONFIG_RTW88_8723CS)	+= rtw88_8723cs.o
rtw88_8723cs-objs		:= rtw8723cs.o

obj-$(CONFIG_RTW88_8723D)	+= rtw88_8723d.o
rtw88_8723d-objs		:= rtw8723d.o rtw8723d_table.o

obj-$(CONFIG_RTW88_8723DE)	+= rtw88_8723de.o
rtw88_8723de-objs		:= rtw8723de.o

obj-$(CONFIG_RTW88_8723DS)	+= rtw88_8723ds.o
rtw88_8723ds-objs		:= rtw8723ds.o

obj-$(CONFIG_RTW88_8723DU)	+= rtw88_8723du.o
rtw88_8723du-objs		:= rtw8723du.o

obj-$(CONFIG_RTW88_8821C)	+= rtw88_8821c.o
rtw88_8821c-objs		:= rtw8821c.o rtw8821c_table.o

obj-$(CONFIG_RTW88_8821CE)	+= rtw88_8821ce.o
rtw88_8821ce-objs		:= rtw8821ce.o

obj-$(CONFIG_RTW88_8821CS)	+= rtw88_8821cs.o
rtw88_8821cs-objs		:= rtw8821cs.o

obj-$(CONFIG_RTW88_8821CU)	+= rtw88_8821cu.o
rtw88_8821cu-objs		:= rtw8821cu.o

obj-$(CONFIG_RTW88_88XXA)	+= rtw88_88xxa.o
rtw88_88xxa-objs		:= rtw88xxa.o

obj-$(CONFIG_RTW88_8821A)	+= rtw88_8821a.o
rtw88_8821a-objs		:= rtw8821a.o rtw8821a_table.o

obj-$(CONFIG_RTW88_8812A)	+= rtw88_8812a.o
rtw88_8812a-objs		:= rtw8812a.o rtw8812a_table.o

obj-$(CONFIG_RTW88_8821AU)	+= rtw88_8821au.o
rtw88_8821au-objs		:= rtw8821au.o

obj-$(CONFIG_RTW88_8812AU)	+= rtw88_8812au.o
rtw88_8812au-objs		:= rtw8812au.o

obj-$(CONFIG_RTW88_PCI)		+= rtw88_pci.o
rtw88_pci-objs			:= pci.o

obj-$(CONFIG_RTW88_SDIO)	+= rtw88_sdio.o
rtw88_sdio-objs			:= sdio.o

obj-$(CONFIG_RTW88_USB)		+= rtw88_usb.o
rtw88_usb-objs			:= usb.o

ccflags-y += -D__CHECK_ENDIAN__

all:
	$(MAKE) -j`nproc` -C $(KSRC) M=$$PWD modules

install: all
	@install -D -m 644 -t $(MODDESTDIR) *.ko
	@install -D -m 644 -t $(FIRMWAREDIR) firmware/*.bin
	@install -D -m 644 -t /etc/modprobe.d blacklist-rtw88.conf

ifeq ($(COMPRESS_GZIP), y)
	@gzip -f $(MODDESTDIR)/*.ko
endif
ifeq ($(COMPRESS_XZ), y)
	@xz -f -C crc32 $(MODDESTDIR)/*.ko
endif
ifeq ($(COMPRESS_ZSTD), y)
	@zstd -f -q --rm $(MODDESTDIR)/*.ko
endif

	@depmod $(DEPMOD_ARGS) -a $(KVER)
	@echo "The rtw88 drivers and firmware files were installed successfully."

uninstall:
	@for mod in $(MODLIST); do \
		rmmod -s $$mod || true; \
	done
	@rm -vf $(MODDESTDIR)/rtw_*.ko*
	@rm -vf /etc/modprobe.d/blacklist-rtw88.conf
	@depmod $(DEPMOD_ARGS)
	@echo "The rtw88 drivers were removed successfully."

clean:
	$(MAKE) -C $(KSRC) M=$$PWD clean
	@rm -f MOK.*

sign:
ifeq ($(NO_SKIP_SIGN), y)
	@openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=Custom MOK/"
	@mokutil --import MOK.der
else
	echo "Skipping key creation"
endif
	@for mod in $(wildcard *.ko); do \
		$(KSRC)/scripts/sign-file sha256 MOK.priv MOK.der $$mod; \
	done

sign-install: all sign install

