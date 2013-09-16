Return-Path: <jcasse@google.com>
MIME-Version: 1.0
Sender: jcasse@google.com
In-Reply-To: <EEF9E3C12F20174DA289A981D6CCA6C8324A3CBF95@MX44A.corp.emc.com>
References: <1379102838-10185-1-git-send-email-jcasse@chromium.org>
	<EEF9E3C12F20174DA289A981D6CCA6C8324A3CBF95@MX44A.corp.emc.com>
Date: Mon, 16 Sep 2013 07:52:51 -0700
Message-ID: <CAPet_23DaVAWzUZ4zpW9XCa54FAF=_zbhdSXh7dM4KjkRR7HWw@mail.gmail.com>
Subject: Re: [PATCH V2] Adds verify_only option.
From: Juan Casse <jcasse@chromium.org>
Content-Type: multipart/mixed; boundary=089e0112d006c54d9b04e6815b1f
To: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Grant Grundler <grundler@chromium.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--089e0112d006c54d9b04e6815b1f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Konstantin,

I use the same code already in fio for stopping. The do_dry_run() uses
the same while-do construct as in do_io().
After the do_dry_run() completes, the do_verify() will verify the io
units that where logged using log_io_piece().

On a related subject:
I found an unexpected behavior with the current version (2.1.2) of fio
when specifying an iodepth > 1 (with a random workload and libaio io
engine and the default random generator and not using a random map).
An example job that produces the behavior is attached.
When a job like that is run, do_io() will perform extra io in the
amount of the extra io that was allowed to accumulate in the queue. In
other words, if iodepth=3D2, fio will do 1 extra io.
I will send a different patch for this.

Regards,
Juan

On Fri, Sep 13, 2013 at 10:53 PM, Ruvinsky, Konstantin
<Konstantin.Ruvinsky@emc.com> wrote:
> Hi Juan,
>
> I removed the second question - understood what you meant.
>
> Regards
> Konstantin
>
> -----Original Message-----
> From: Ruvinsky, Konstantin
> Sent: Saturday, September 14, 2013 8:34 AM
> To: 'Juan Casse'; 'fio@vger.kernel.org'
> Subject: RE: [PATCH V2] Adds verify_only option.
>
> Hi Juan,
>
> Two questions:
> 1. How fio knows where is the last block (where to stop verification run)=
? Please let me know if I understand it correctly: because lfsr runs withou=
t duplicated blocks then number of iterations is device_size/block_size.
> 2. You wrote: "The verify_only option performs only verification (reads p=
erformed in do_verify()) and no read or write workload". But for verificati=
on, even if you made dry run till the end, you need to read. I don't follow=
.
>
> Regards
> Konstantin
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Beh=
alf Of Juan Casse
> Sent: Friday, September 13, 2013 11:07 PM
> To: Jens Axboe
> Cc: Grant Grundler; fio@vger.kernel.org; Juan Casse
> Subject: [PATCH V2] Adds verify_only option.
>
> The verify_only option performs only verification (reads performed in do_=
verify()) and no read or write workload. The goal is to verify previously w=
ritten meta data quickly and be able to detect stale data.
> Without this option, fio does not detect stale data from previous fio run=
s---only data corruption of "misplaced" data.
>
> This option replays the specified write workload sequence in order to com=
pute the "generation number" (using numberio field) for each block header t=
hat was written in a previous fio run. The numberio field is used to detect=
 stale data. do_verify() checks numberio only in the last iteration, after =
the correct numberio for each block has been computed.

--089e0112d006c54d9b04e6815b1f
Content-Type: application/octet-stream; name="jcasse_job.fio"
Content-Disposition: attachment; filename="jcasse_job.fio"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlnsyk1s0

W2dsb2JhbF0KZmlsZW5hbWU9amNhc3NlX2RhdGEKc2l6ZT0yNGsKYnM9OGsKbG9vcHM9MQpyYW5k
cmVwZWF0PTEKdmVyaWZ5PW1ldGEKdmVyaWZ5X3BhdHRlcm49MHhmZmZmZmZmZmZmZmZmZmZmCnZl
cmlmeV9kdW1wPTAKY29udGludWVfb25fZXJyb3I9dmVyaWZ5CgpbamNhc3NlX2pvYl0KcmVhZHdy
aXRlPXJhbmR3cml0ZQppb2RlcHRoPTIKaW9lbmdpbmU9bGliYWlvCnJhbmRvbV9nZW5lcmF0b3I9
dGF1c3dvcnRoZQpub3JhbmRvbW1hcAo=
--089e0112d006c54d9b04e6815b1f--


