Return-Path: <axboe@kernel.dk>
Message-ID: <53CD616D.1030908@kernel.dk>
Date: Mon, 21 Jul 2014 20:52:29 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [fio-2.1.9] verify and bssplit do not work together
References: <CAMHSBOXb0f9iZFLiJSXPiT+8yXe8QbF-bS_4KA1c1+=Wps_K_A@mail.gmail.com> <53C8D124.60202@kernel.dk> <53CCCF60.9090208@kernel.dk> <CAMHSBOW1g2y9nCMQs=qJ-ggWZEG_MiG27BgpttPFsk1tdUQy5g@mail.gmail.com> <53CD5EA6.4090706@kernel.dk>
In-Reply-To: <53CD5EA6.4090706@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------050508080906060300050803"
To: Gwendal Grignou <gwendal@chromium.org>
Cc: Puthikorn Voravootivat <puthik@chromium.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050508080906060300050803
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-07-21 20:40, Jens Axboe wrote:
>> But looking at the code, it won't be possible to fix, because we can
>> not guarantee to always have 16 4K write contiguous.
>
> As mentioned in the original email, it's a parser fix. verify_interval
> cannot be less than the minimum block size, fio will just have to catch
> that and adjust / error out.

Attach should fix that - untested...

-- 
Jens Axboe


--------------050508080906060300050803
Content-Type: text/x-patch;
 name="x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="x.patch"

diff --git a/init.c b/init.c
index cf1d7f938fb3..cf2f82220f72 100644
--- a/init.c
+++ b/init.c
@@ -635,6 +635,9 @@ static int fixup_options(struct thread_data *td)
 		if (o->max_bs[DDIR_WRITE] != o->min_bs[DDIR_WRITE] &&
 		    !o->verify_interval)
 			o->verify_interval = o->min_bs[DDIR_WRITE];
+
+		if (o->verify_interval > o->min_bs[DDIR_WRITE])
+			o->verify_interval = o->min_bs[DDIR_WRITE];
 	}
 
 	if (o->pre_read) {

--------------050508080906060300050803--

