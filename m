Return-Path: <fio-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35636 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161317Ab3DKR5j convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 11 Apr 2013 13:57:39 -0400
From: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>
Subject: Make FIO for Android
Date: Thu, 11 Apr 2013 17:57:37 +0000
Message-ID: <428EE8BD-3617-404A-8661-792573E308D5@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D07EA445A4C67E4E8FBDA2F46F96E774@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I would like to make FIO for Android source. I tried Aaron's post and ran into problems. I also tried making a Android.mk and got into undeclared values for __NR_shm*

When I make here is what i get..

akrish9@akrish9-ws:~/setup/fio [master] $ make V=1 UNAME=Android cross_prefix=~/android-ndk-r8e/toolchains/x86-4.6/prebuilt/linux-x86_64/bin/i686-linux-android-
Makefile:12: config-host.mak: No such file or directory
Running configure for you...
compile test failed
Configure failed, check config.log and/or the above output



when i try to configure i get this..

akrish9@akrish9-ws:~/setup/fio [master] $ ./configure --cpu=i386 --extra-cflags="-D__ANDROID__" --cc=/home/akrish9/android-ndk-r8e/toolchains/x86-4.6/prebuilt/linux-x86_64/i686-linux-android/bin/gcc
compile test failed
Configure failed, check config.log and/or the above output
akrish9@akrish9-ws:~/setup/fio [master] $ cat config.log
# FIO configure log Thu Apr 11 10:46:48 MST 2013
# Configured with: './configure' '--cpu=i386' '--extra-cflags=-D__ANDROID__' '--cc=/home/akrish9/android-ndk-r8e/toolchains/x86-4.6/prebuilt/linux-x86_64/i686-linux-android/bin/gcc'
#
gcc -D_GNU_SOURCE -include config-host.h -D__ANDROID__ -c -o /tmp/fio-conf--4681-.o /tmp/fio-conf--4681-.c
Compiling test case cross


Any help here is appreciated.

Thanks,
Anush Krishnamurthy




