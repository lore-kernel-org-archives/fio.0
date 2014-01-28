Return-Path: <grundler@google.com>
MIME-Version: 1.0
Sender: grundler@google.com
In-Reply-To: <20140128220349.GD25989@kernel.dk>
References: <1390942940-6886-1-git-send-email-grundler@chromium.org>
	<20140128213014.GC31710@kernel.dk>
	<CANEJEGvZ3xnkg+D8RwVcvHfTKtVCcm_YP_geskOZTC0UNBnGOA@mail.gmail.com>
	<20140128220349.GD25989@kernel.dk>
Date: Tue, 28 Jan 2014 14:14:33 -0800
Message-ID: <CANEJEGurTpsgV5gUv1758dvE7UtP2zqNP6aLe4S69Ezo4i5yVA@mail.gmail.com>
Subject: Re: [PATCH] fio: consolidate rand_seed to uint64_t
From: Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: Grant Grundler <grundler@chromium.org>, FIO List <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

On Tue, Jan 28, 2014 at 2:03 PM, Jens Axboe <axboe@kernel.dk> wrote:
...
>> -       o->rand_seed =3D le32_to_cpu(top->rand_seed);
>> +       o->rand_seed =3D le64_to_cpu(top->rand_seed);
>>
>> I saw this when reviewing the code but didn't realize "top" was the
>> packed version that got changed.
>
> Yeah, and vice versa for top -> o.

Oh! :(

(And I assume you mean line 288 as shown below)

If I add this:

diff --git a/cconv.c b/cconv.c
index c4941ba..57996fb 100644
--- a/cconv.c
+++ b/cconv.c
@@ -285,7 +285,7 @@ void convert_thread_options_to_net(struct thread_option=
s_pac
        top->do_disk_util =3D cpu_to_le32(o->do_disk_util);
        top->override_sync =3D cpu_to_le32(o->override_sync);
        top->rand_repeatable =3D cpu_to_le32(o->rand_repeatable);
-       top->rand_seed =3D cpu_to_le32(o->rand_seed);
+       top->rand_seed =3D cpu_to_le64(o->rand_seed);
        top->use_os_rand =3D cpu_to_le32(o->use_os_rand);
        top->log_avg_msec =3D cpu_to_le32(o->log_avg_msec);
        top->norandommap =3D cpu_to_le32(o->norandommap);

I get this warning:

grundler <2090>make V=3D1
gcc -o cconv.o -std=3Dgnu99 -Wwrite-strings -Wall
-Wdeclaration-after-statement -O3 -g -ffast-math  -D_GNU_SOURCE
-include config-host.h -DBITS_PER_LONG=3D64
-DFIO_VERSION=3D'"fio-2.1.4-26-g3a2a"' -D_LARGEFILE_SOURCE
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG -c cconv.c

    CC cconv.o
cconv.c: In function =E2=80=98convert_thread_options_to_net=E2=80=99:
cconv.c:288:19: warning: initialization from incompatible pointer type
[enabled by default]
    LINK fio

grundler <2091>file cconv.o
cconv.o: ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped

286         top->override_sync =3D cpu_to_le32(o->override_sync);
287         top->rand_repeatable =3D cpu_to_le32(o->rand_repeatable);
288         top->rand_seed =3D cpu_to_le64(o->rand_seed);
289         top->use_os_rand =3D cpu_to_le32(o->use_os_rand);
290         top->log_avg_msec =3D cpu_to_le32(o->log_avg_msec);

Now I'm just confused.

grant

