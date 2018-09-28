Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
Message-ID: <1538166304.53591.6.camel@acm.org>
Subject: Re: [PATCH] zbd: Restore check_swd()
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 28 Sep 2018 13:25:04 -0700
In-Reply-To: <b3169357-303b-30e2-9018-d889e53c6a97@kernel.dk>
References: <20180927021648.28313-1-damien.lemoal@wdc.com>
	 <40ca898f-febc-b403-74ec-f7df39c0bb7f@kernel.dk>
	 <BN3PR0401MB1640312E62830C451665E507E7EC0@BN3PR0401MB1640.namprd04.prod.outlook.com>
	 <BLUPR0401MB16361E2E31658E293C266970E7EC0@BLUPR0401MB1636.namprd04.prod.outlook.com>
	 <b3169357-303b-30e2-9018-d889e53c6a97@kernel.dk>
Content-Type: text/plain; charset="UTF-7"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, 2018-09-28 at 08:54 -0600, Jens Axboe wrote:
+AD4 +-	for (z +AD0 zb+ADs z +ADw ze+ADs z+-+-) +AHs
+AD4 +-		pthread+AF8-mutex+AF8-lock(+ACY-z-+AD4-mutex)+ADs
+AD4 +-		swd +-+AD0 z-+AD4-wp - z-+AD4-start+ADs
+AD4 +-	+AH0
+AD4 +-	pthread+AF8-mutex+AF8-lock(+ACY-f-+AD4-zbd+AF8-info-+AD4-mutex)+ADs
+AD4 
+AD4 Can 'z' ever end up being f-+AD4-zbd+AF8-info? That would surely explain the
+AD4 deadlock.

Hi Jens,

f-+AD4-zbd+AF8-info and z have a different type so unless something very weird is going
on +ACY-z-+AD4-mutex can't be identical to +ACY-f-+AD4-zbd+AF8-info-+AD4-mutex.

What I think is going on is traditional lock inversion: check+AF8-swd() triggers
lock inversion if it is called while any of the z-+AD4-mutex objects are held. One
such mutex is held where Damien tried to restore the calls of this function. I
will submit a patch that inserts these calls elsewhere.

Bart.


