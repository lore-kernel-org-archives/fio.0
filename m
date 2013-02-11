Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:56941 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab3BKQNu convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 11 Feb 2013 11:13:50 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so4895533wgb.12
        for <fio@vger.kernel.org>; Mon, 11 Feb 2013 08:13:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACTzACVkfEmHrCTJExxOpPqD7tZLMbmW7n3pJza-g87sZaaK1g@mail.gmail.com>
References: <CACTzACVkfEmHrCTJExxOpPqD7tZLMbmW7n3pJza-g87sZaaK1g@mail.gmail.com>
Date: Mon, 11 Feb 2013 11:13:42 -0500
Message-ID: <CACTzACUwtE+aoHy72dAvgcx8zby5DYwYZzhoJfOyTCj5ABCGgg@mail.gmail.com>
Subject: problem FIO compiling for Android
From: David N <android.wm.edu@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello Everyone,

I've been trying to compile FIO for Android but keep getting error
bellow. Can anybody give me any guidance please?

I very much appreciate!

David


david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ make
UNAME=3DAndroid CROSS_COMPILE=3D$CCOMPILER
    CC init.o
init.c: In function =EF=BF=BDfree_shm=EF=BF=BD:
init.c:224:18: error: storage size of =EF=BF=BDsbuf=EF=BF=BD isn=EF=BF=BDt =
known
init.c:233:3: warning: implicit declaration of function =EF=BF=BDshmdt=EF=
=BF=BD
[-Wimplicit-function-declaration]
init.c:234:3: warning: implicit declaration of function =EF=BF=BDshmctl=EF=
=BF=BD
[-Wimplicit-function-declaration]
init.c:224:18: warning: unused variable =EF=BF=BDsbuf=EF=BF=BD [-Wunused-va=
riable]
init.c: In function =EF=BF=BDsetup_thread_area=EF=BF=BD:
init.c:263:3: warning: implicit declaration of function =EF=BF=BDshmget=EF=
=BF=BD
[-Wimplicit-function-declaration]
init.c:277:2: warning: implicit declaration of function =EF=BF=BDshmat=EF=
=BF=BD
[-Wimplicit-function-declaration]
init.c:277:10: warning: assignment makes pointer from integer without
a cast [enabled by default]
make: *** [init.o] Error 1
