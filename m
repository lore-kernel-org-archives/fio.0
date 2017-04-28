Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:35488 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2997758AbdD1XBK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Apr 2017 19:01:10 -0400
Received: by mail-pf0-f182.google.com with SMTP id v14so54495080pfd.2
        for <fio@vger.kernel.org>; Fri, 28 Apr 2017 16:01:09 -0700 (PDT)
Received: from host-14-225.miancou.clients.pavlovmedia.com (host-14-225.miancou.clients.pavlovmedia.com. [76.10.14.225])
        by smtp.gmail.com with ESMTPSA id 17sm10770510pgg.48.2017.04.28.16.01.08
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Apr 2017 16:01:08 -0700 (PDT)
From: Omri Mor <omor1@asu.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Compiling on Android using ndk-r15 or higher
Message-Id: <E09D8C27-9FE6-4BD6-B751-92BD34AD66D5@asu.edu>
Date: Fri, 28 Apr 2017 16:01:07 -0700
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Description
Building using ndk-r15 will result in a build failure:
./os/os-android.h:87:7: error: redefinition of 'key' with a different =
type: 'char [11]' vs 'key_t' (aka 'int=E2=80=99)

Environment
Targeting Android API level 21 for arm-linux-androideabi with a =
standalone toolchain from ndk-r14 with a patched <sys/ipc.h> (backported =
from  ndk-r15).

Version
fio-2.19

Reproduction
Compile for Android using ndk-r15 or higher (or at least a patched =
<sys/ipc.h>).

More Information
Bionic in Android ndk-r15 makes changes to <sys/ipc.h> to work around =
inconsistencies between glibc and kernel declarations in struct =
ipc64_perm. See =
https://sourceforge.net/p/strace/mailman/message/35628355/ for more =
information on why the change was necessary.
<sys/ipc.h> now defines __key as key and __seq as seq
In os/os-android.h, shmget is declared as: static inline int shmget =
(key_t __key, size_t __size, int __shmflg)
Inside the function the variable char key[11] is declared.
With the new definitions in <sys/ipc.h>, the __key parameter and the key =
variable conflict (as __key is replaced by key).
The fix is simply renaming key to some other name.
I haven=E2=80=99t formally tested using ndk-r15 as it is still in beta, =
but I am using the same fix for <sys/ipc.h>. See =
https://android.googlesource.com/platform/bionic/+/a29821bb455e6c23b2c9fe1=
3bf1436610c4eb412%5E%21/#F0 for the patch to Bionic.=
