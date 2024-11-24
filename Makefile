#
# **************************************************************
# *                                                            *
# * Author: sunbin (2025)                                      *
# * URL: https://cdn.kernel.org/pub/linux/kernel				   		   *
# *                                                            *
# * Copyright notice:                                          *
# * Free use of this C++ Makefile template is permitted under  *
# * the guidelines and in accordance with the the MIT License  *
# * http://www.opensource.org/licenses/MIT                     *
# *                                                            *
# **************************************************************
#

TOPDIR := $(shell /bin/pwd)
core_src_dir = $(TOPDIR)
build_dir = $(TOPDIR)/build

.build_kernel:
	@echo "-------------- setup tree --------------"
	@if [ ! -d build_dir ]; then mkdir -p $(build_dir); fi
	@if [ ! -d $(kernel_build_dir) ]; then rm -rf $(kernel_build_dir); fi
	@mkdir -p $(kernel_build_dir)
	@echo "-------------- copy sources --------------"
	@tar -Jxf $(os_src_dir)/kernel/$(KERNEL_VERSION)_src/linux-*.tar.xz -C $(kernel_build_dir)
	@cp -af $(os_src_dir)/kernel/$(KERNEL_VERSION)_src/kernel.spec $(kernel_buid_dir)/linux-$(KERNEL_VERSION)
	#@cp -af $(os_src_dir)/kernel/$(KERNEL_VERSION)_src/*.patch $(kernel_build_dir)/linux-$(KERNEL_VERSION)/.config
	@cp -af $(os_src_dir)/kernel/$(KERNEL_VERSION)_src/defconfig $(kernel)/linux-$(KERNEL_VERSION)/.config
	@echo "-------------- copy sources --------------"
	#@(cd $(kernel_build_dir);  \
	#	for pathfig in *.patch; do  \
	#		patch -d linux-$(KERNEL_VERSION) -p1 < $$patchfile; \
	#	done)
	@sed -i "s/^Release: \s*.*/Release: $(KERNEL_RELEASE)/" $(kernel_build_dir)/linux-$(KERNEL_VERSION)/kernel.spec
	@echo $(KERNEL_RELEASE) > $(kernel_buid_dir)/linux-$(KERNEL_VERSION)/.KERNEL_VERSION
	@(cp $(kernel_build_dir)/linux-$(KERNEL_VERSION); make rpm-pkg -j 12)
	@echo "-------------- copy sources --------------"
	(cd ~/rpmbuild/RPMS/x86_64; \
		rm -f $(os_src_dir)/kernel/$(KERNEL_VERSION)/kernel-*.x86_64.rpm; \
		cp -af kernel-*(KERNEL_VERSION)-$(KERNEL_RELEASE).x86_64.rpm $(os_src_dir)/kernel/$(KERNEL_VERSION);)
	@echo "-------------- Completed kernel build --------------"
	@touch .build_kernel




