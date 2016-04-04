Return-Path: <logang@deltatee.com>
References: <CAANLjFrvQhEt02+7csMxnBg_fvLyJ8DWWxnAWf1MExSQTqCpMw@mail.gmail.com>
 <57013E24.8090607@kernel.dk> <5701599D.2090209@deltatee.com>
 <CAANLjFpbkM_zQwZ7=uHpJ0iJ_4qJSJw0dxV+z3Q_chvNNp31FQ@mail.gmail.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <570294C9.1050502@deltatee.com>
Date: Mon, 4 Apr 2016 10:22:33 -0600
MIME-Version: 1.0
In-Reply-To: <CAANLjFpbkM_zQwZ7=uHpJ0iJ_4qJSJw0dxV+z3Q_chvNNp31FQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: fio: rdma_create_event_channel fail
To: Robert LeBlanc <robert@leblancnet.us>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hey,

I've created a patch on github that will print slightly more information
in the error message. If you could try it and post the output it may
shine some more light on the situation:

https://github.com/axboe/fio/pull/160
https://github.com/lsgunth/fio/tree/rdma_err

It may also be worth sending the output of ibstat and maybe lsmod as well.

Logan


On 03/04/16 04:38 PM, Robert LeBlanc wrote:
> I'm able to do ibstat and everything is up. I can do ibping between the
> nodes and iSER is working properly. I have not done ib_write_bw but I
> can try it tomorrow if you think it would help.
> 
> I included the entire message from fio. Can you give me some more
> information about additional error messages you may needed.
> 
> Sent from a mobile device, please excuse any typos.
> 
> On Apr 3, 2016 11:57 AM, "Logan Gunthorpe" <logang@deltatee.com
> <mailto:logang@deltatee.com>> wrote:
> 
>     Hi Robert,
> 
>     It looks like rdma_create_event_channel has failed which is a pretty
>     basic part of the RDMA initialization. To me, this likely indicates
>     your RDMA setup is broken. Do commands like ibstatus and ibv_devices
>     report active interfaces? Do other RDMA test programs like
>     ib_write_bw, etc (from the perftest package) work?
> 
>     It may be worth printing the errno with that error message, I may
>     have time to make a patch to that effect tomorrow.
> 
>     Logan
> 
>     On 03/04/16 10:00 AM, Jens Axboe wrote:
> 
>         CC'ing Logan, who might have an idea.
> 
> 
>         On 03/31/2016 10:44 AM, Robert LeBlanc wrote:
> 
>             -----BEGIN PGP SIGNED MESSAGE-----
>             Hash: SHA256
> 
>             When trying to use the RDMA engine and the example job for
>             the server
>             with the port set to an arbitrary value I get:
> 
>             # /home/rleblanc/fio/fio
>             /home/rleblanc/fio/examples/rdmaio-server.fio
>             receiver: (g=0): rw=read, bs=1M-1M/1M-1M/1M-1M,
>             ioengine=rdma, iodepth=16
>             fio-2.8-14-g23a8
>             Starting 1 process
>             fio: rdma_create_event_channel fail
>             fio: io engine init failed. Perhaps try reducing io depth?
>             fio: pid=18588, err=1/
> 
>             Setting I/O depth=1 only removed the corresponding message
>             from the
>             output.
>             # uname -r
>             4.1.15.bs.ufd
> 
>             # rpm -qa | grep -E "ibverbs|rdmacm"
>             libibverbs-devel-1.1.8-8.el7.x86_64
>             librdmacm-1.0.21-1.el7.x86_64
>             libibverbs-1.1.8-8.el7.x86_64
>             librdmacm-devel-1.0.21-1.el7.x86_64
> 
>             I'm not sure what is wrong as this is the first time I've
>             tried using
>             the RDMA engine.
>             - ----------------
>             Robert LeBlanc
>             PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2
>             FA62 B9F1
>             -----BEGIN PGP SIGNATURE-----
>             Version: Mailvelope v1.3.6
>             Comment: https://www.mailvelope.com
> 
>             wsFcBAEBCAAQBQJW/VPPCRDmVDuy+mK58QAAPKMQAJF8B3y8pk9l2emtsrGm
>             2Rt7ufstv6c4XtuCk2wsc6ocZe8yNfAM1BNkW6pTF96orHZuLTt/QDvbDlnN
>             q6N0vPkGJbDVbm7YNDzFc4qOU1pbrn8a66eck5BKuHPPogXCsJJTu+rdfAd9
>             TNUGD4b9MzogTCzI8Zs6YRdWLIeaJRsPaHqJGYsD5G83rxGFagjx0qoOPuF+
>             CNcFVYXZeU3+/YzsTDfuvNtiSDDJTUe3Shjw6fSu8ZFNabucAbbGOflovIIL
>             kGjFmprrFgqOLiTnw7muF6tSXcc205YMGbCgOiEye4i9Ajd/ITiEQ3QlbQZ1
>             WDz5WPSukDR8KqJoREKcksWVL7zVciulE5/+ZlJajD02JfOTz7j9QydLAPJ/
>             sQM1g7Ft5HZK8TB9IgVKBernHCpahNQ5dU2OadDgpe0rxjzjrVcxegYOqLPd
>             iUVFT2/UUFwzxaVnxHXTDNGO5A4JSyctvPTQ4uKLFFox9p6L5pFgrz9o86Fs
>             lbW/72IjJD/8AEC64cqJp6JuC/sSEmz2hPpOvKdbpWPlVijzPB0OnpkMB4cC
>             DATo4afT5uDRDe7IS8Ypi/WcriVLA+O9jRsigARri1F4FFc1QR/FDtXQnKYE
>             SKB8sOE6sAv8qsyNLDqyD3rAzjRJ267zweNcWficcrHD3pYljXCLK1oaZgHD
>             EcOB
>             =f1X7
>             -----END PGP SIGNATURE-----
>             --
>             To unsubscribe from this list: send the line "unsubscribe
>             fio" in
>             the body of a message to majordomo@vger.kernel.org
>             <mailto:majordomo@vger.kernel.org>
>             More majordomo info at 
>             http://vger.kernel.org/majordomo-info.html
> 
> 
> 

