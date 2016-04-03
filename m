Return-Path: <robert@leblancnet.us>
MIME-Version: 1.0
In-Reply-To: <5701599D.2090209@deltatee.com>
References: <CAANLjFrvQhEt02+7csMxnBg_fvLyJ8DWWxnAWf1MExSQTqCpMw@mail.gmail.com>
	<57013E24.8090607@kernel.dk>
	<5701599D.2090209@deltatee.com>
Date: Sun, 3 Apr 2016 16:38:02 -0600
Message-ID: <CAANLjFpbkM_zQwZ7=uHpJ0iJ_4qJSJw0dxV+z3Q_chvNNp31FQ@mail.gmail.com>
Subject: Re: fio: rdma_create_event_channel fail
From: Robert LeBlanc <robert@leblancnet.us>
Content-Type: multipart/alternative; boundary=001a1140f23cd53988052f9c4380
To: Logan Gunthorpe <logang@deltatee.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--001a1140f23cd53988052f9c4380
Content-Type: text/plain; charset=UTF-8

I'm able to do ibstat and everything is up. I can do ibping between the
nodes and iSER is working properly. I have not done ib_write_bw but I can
try it tomorrow if you think it would help.

I included the entire message from fio. Can you give me some more
information about additional error messages you may needed.

Sent from a mobile device, please excuse any typos.
On Apr 3, 2016 11:57 AM, "Logan Gunthorpe" <logang@deltatee.com> wrote:

> Hi Robert,
>
> It looks like rdma_create_event_channel has failed which is a pretty basic
> part of the RDMA initialization. To me, this likely indicates your RDMA
> setup is broken. Do commands like ibstatus and ibv_devices report active
> interfaces? Do other RDMA test programs like ib_write_bw, etc (from the
> perftest package) work?
>
> It may be worth printing the errno with that error message, I may have
> time to make a patch to that effect tomorrow.
>
> Logan
>
> On 03/04/16 10:00 AM, Jens Axboe wrote:
>
>> CC'ing Logan, who might have an idea.
>>
>>
>> On 03/31/2016 10:44 AM, Robert LeBlanc wrote:
>>
>>> -----BEGIN PGP SIGNED MESSAGE-----
>>> Hash: SHA256
>>>
>>> When trying to use the RDMA engine and the example job for the server
>>> with the port set to an arbitrary value I get:
>>>
>>> # /home/rleblanc/fio/fio /home/rleblanc/fio/examples/rdmaio-server.fio
>>> receiver: (g=0): rw=read, bs=1M-1M/1M-1M/1M-1M, ioengine=rdma, iodepth=16
>>> fio-2.8-14-g23a8
>>> Starting 1 process
>>> fio: rdma_create_event_channel fail
>>> fio: io engine init failed. Perhaps try reducing io depth?
>>> fio: pid=18588, err=1/
>>>
>>> Setting I/O depth=1 only removed the corresponding message from the
>>> output.
>>> # uname -r
>>> 4.1.15.bs.ufd
>>>
>>> # rpm -qa | grep -E "ibverbs|rdmacm"
>>> libibverbs-devel-1.1.8-8.el7.x86_64
>>> librdmacm-1.0.21-1.el7.x86_64
>>> libibverbs-1.1.8-8.el7.x86_64
>>> librdmacm-devel-1.0.21-1.el7.x86_64
>>>
>>> I'm not sure what is wrong as this is the first time I've tried using
>>> the RDMA engine.
>>> - ----------------
>>> Robert LeBlanc
>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>> -----BEGIN PGP SIGNATURE-----
>>> Version: Mailvelope v1.3.6
>>> Comment: https://www.mailvelope.com
>>>
>>> wsFcBAEBCAAQBQJW/VPPCRDmVDuy+mK58QAAPKMQAJF8B3y8pk9l2emtsrGm
>>> 2Rt7ufstv6c4XtuCk2wsc6ocZe8yNfAM1BNkW6pTF96orHZuLTt/QDvbDlnN
>>> q6N0vPkGJbDVbm7YNDzFc4qOU1pbrn8a66eck5BKuHPPogXCsJJTu+rdfAd9
>>> TNUGD4b9MzogTCzI8Zs6YRdWLIeaJRsPaHqJGYsD5G83rxGFagjx0qoOPuF+
>>> CNcFVYXZeU3+/YzsTDfuvNtiSDDJTUe3Shjw6fSu8ZFNabucAbbGOflovIIL
>>> kGjFmprrFgqOLiTnw7muF6tSXcc205YMGbCgOiEye4i9Ajd/ITiEQ3QlbQZ1
>>> WDz5WPSukDR8KqJoREKcksWVL7zVciulE5/+ZlJajD02JfOTz7j9QydLAPJ/
>>> sQM1g7Ft5HZK8TB9IgVKBernHCpahNQ5dU2OadDgpe0rxjzjrVcxegYOqLPd
>>> iUVFT2/UUFwzxaVnxHXTDNGO5A4JSyctvPTQ4uKLFFox9p6L5pFgrz9o86Fs
>>> lbW/72IjJD/8AEC64cqJp6JuC/sSEmz2hPpOvKdbpWPlVijzPB0OnpkMB4cC
>>> DATo4afT5uDRDe7IS8Ypi/WcriVLA+O9jRsigARri1F4FFc1QR/FDtXQnKYE
>>> SKB8sOE6sAv8qsyNLDqyD3rAzjRJ267zweNcWficcrHD3pYljXCLK1oaZgHD
>>> EcOB
>>> =f1X7
>>> -----END PGP SIGNATURE-----
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
>>

--001a1140f23cd53988052f9c4380
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">I&#39;m able to do ibstat and everything is up. I can do ibp=
ing between the nodes and iSER is working properly. I have not done ib_writ=
e_bw but I can try it tomorrow if you think it would help. </p>
<p dir=3D"ltr">I included the entire message from fio. Can you give me some=
 more information about additional error messages you may needed. </p>
<p dir=3D"ltr">Sent from a mobile device, please excuse any typos.</p>
<div class=3D"gmail_quote">On Apr 3, 2016 11:57 AM, &quot;Logan Gunthorpe&q=
uot; &lt;<a href=3D"mailto:logang@deltatee.com">logang@deltatee.com</a>&gt;=
 wrote:<br type=3D"attribution"><blockquote class=3D"gmail_quote" style=3D"=
margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi Robert,<b=
r>
<br>
It looks like rdma_create_event_channel has failed which is a pretty basic =
part of the RDMA initialization. To me, this likely indicates your RDMA set=
up is broken. Do commands like ibstatus and ibv_devices report active inter=
faces? Do other RDMA test programs like ib_write_bw, etc (from the perftest=
 package) work?<br>
<br>
It may be worth printing the errno with that error message, I may have time=
 to make a patch to that effect tomorrow.<br>
<br>
Logan<br>
<br>
On 03/04/16 10:00 AM, Jens Axboe wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
CC&#39;ing Logan, who might have an idea.<br>
<br>
<br>
On 03/31/2016 10:44 AM, Robert LeBlanc wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
-----BEGIN PGP SIGNED MESSAGE-----<br>
Hash: SHA256<br>
<br>
When trying to use the RDMA engine and the example job for the server<br>
with the port set to an arbitrary value I get:<br>
<br>
# /home/rleblanc/fio/fio /home/rleblanc/fio/examples/rdmaio-server.fio<br>
receiver: (g=3D0): rw=3Dread, bs=3D1M-1M/1M-1M/1M-1M, ioengine=3Drdma, iode=
pth=3D16<br>
fio-2.8-14-g23a8<br>
Starting 1 process<br>
fio: rdma_create_event_channel fail<br>
fio: io engine init failed. Perhaps try reducing io depth?<br>
fio: pid=3D18588, err=3D1/<br>
<br>
Setting I/O depth=3D1 only removed the corresponding message from the<br>
output.<br>
# uname -r<br>
4.1.15.bs.ufd<br>
<br>
# rpm -qa | grep -E &quot;ibverbs|rdmacm&quot;<br>
libibverbs-devel-1.1.8-8.el7.x86_64<br>
librdmacm-1.0.21-1.el7.x86_64<br>
libibverbs-1.1.8-8.el7.x86_64<br>
librdmacm-devel-1.0.21-1.el7.x86_64<br>
<br>
I&#39;m not sure what is wrong as this is the first time I&#39;ve tried usi=
ng<br>
the RDMA engine.<br>
- ----------------<br>
Robert LeBlanc<br>
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904=C2=A0 C70E E654 3BB2 FA62 B9F1<br>
-----BEGIN PGP SIGNATURE-----<br>
Version: Mailvelope v1.3.6<br>
Comment: <a href=3D"https://www.mailvelope.com" rel=3D"noreferrer" target=
=3D"_blank">https://www.mailvelope.com</a><br>
<br>
wsFcBAEBCAAQBQJW/VPPCRDmVDuy+mK58QAAPKMQAJF8B3y8pk9l2emtsrGm<br>
2Rt7ufstv6c4XtuCk2wsc6ocZe8yNfAM1BNkW6pTF96orHZuLTt/QDvbDlnN<br>
q6N0vPkGJbDVbm7YNDzFc4qOU1pbrn8a66eck5BKuHPPogXCsJJTu+rdfAd9<br>
TNUGD4b9MzogTCzI8Zs6YRdWLIeaJRsPaHqJGYsD5G83rxGFagjx0qoOPuF+<br>
CNcFVYXZeU3+/YzsTDfuvNtiSDDJTUe3Shjw6fSu8ZFNabucAbbGOflovIIL<br>
kGjFmprrFgqOLiTnw7muF6tSXcc205YMGbCgOiEye4i9Ajd/ITiEQ3QlbQZ1<br>
WDz5WPSukDR8KqJoREKcksWVL7zVciulE5/+ZlJajD02JfOTz7j9QydLAPJ/<br>
sQM1g7Ft5HZK8TB9IgVKBernHCpahNQ5dU2OadDgpe0rxjzjrVcxegYOqLPd<br>
iUVFT2/UUFwzxaVnxHXTDNGO5A4JSyctvPTQ4uKLFFox9p6L5pFgrz9o86Fs<br>
lbW/72IjJD/8AEC64cqJp6JuC/sSEmz2hPpOvKdbpWPlVijzPB0OnpkMB4cC<br>
DATo4afT5uDRDe7IS8Ypi/WcriVLA+O9jRsigARri1F4FFc1QR/FDtXQnKYE<br>
SKB8sOE6sAv8qsyNLDqyD3rAzjRJ267zweNcWficcrHD3pYljXCLK1oaZgHD<br>
EcOB<br>
=3Df1X7<br>
-----END PGP SIGNATURE-----<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe fio&quot; in=
<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org" targe=
t=3D"_blank">majordomo@vger.kernel.org</a><br>
More majordomo info at=C2=A0 <a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" rel=3D"noreferrer" target=3D"_blank">http://vger.kernel.org/majord=
omo-info.html</a><br>
<br>
</blockquote>
<br>
<br>
</blockquote>
</blockquote></div>

--001a1140f23cd53988052f9c4380--

