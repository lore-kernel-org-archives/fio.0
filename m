Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33166 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939880AbdD1Q5R (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Apr 2017 12:57:17 -0400
Received: by mail-io0-f169.google.com with SMTP id k87so70617223ioi.0
        for <fio@vger.kernel.org>; Fri, 28 Apr 2017 09:57:16 -0700 (PDT)
From: Bryan Gurney <bgurney@permabit.com>
References: <07fa4af4953de5cca876fdc266a4356c@mail.gmail.com> <CALjAwxjXO51xx1F==-axhdxyGnjTr-A=8iM-nBrue5wfNec=ow@mail.gmail.com>
In-Reply-To: <CALjAwxjXO51xx1F==-axhdxyGnjTr-A=8iM-nBrue5wfNec=ow@mail.gmail.com>
MIME-Version: 1.0
Date: Fri, 28 Apr 2017 12:57:14 -0400
Message-ID: <b89dec9fda49e43baa8276de39b7c8af@mail.gmail.com>
Subject: RE: Running fio with buffer_compress_percentage=0 and
 scramble_buffers=1 produces high-dedupe data
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio@vger.kernel.org

> Hi,
>
> On 26 April 2017 at 21:19, Bryan Gurney <bgurney@permabit.com> wrote:
> >
> > I performed some tests for various non-zero values of
> > "buffer_compress_percentage", and the resulting data was not dedupable
> > (which would be consistent with the behavior of "scramble_buffers=1",
> > but
> > the data pattern seems to suggest that the algorithm used in
> > scramble_buffers is not being used.  Comparing this to when
> > buffer_compress_percentage is set to zero, the resulting data is almost
> > incompressible, but exhibits a high frequency of dedupe.  This is
> > despite
> > the intentions of the user's configuration for buffer data content of 0%
> > compression, and scrambled to avoid dedupe.
>
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-buffer-compress-percentage
> alludes to buffer_compress_percentage=0 actually turning the option
> off rather than setting a compression ratio of 0%. Here's a link to
> the code that would normally react to the option:
> https://github.com/axboe/fio/blob/fio-2.19/io_u.c#L2045 .
>
> --
> Sitsofe | http://sucs.org/~sits/
>


Hi Sitsofe,

Thanks, I actually didn't know about that part in fill_io_buffer(), which
ultimately disables compression by the nature of the
buffer_compress_percentage value being 0.

However, the part that caught my attention was also in io_u.c, inside the
function "struct io_u *get_io_u(struct thread_data *td)", starting here:
https://github.com/axboe/fio/blob/fio-2.19/io_u.c#L1644

	if (io_u->ddir == DDIR_WRITE) {
			if (td->flags & TD_F_REFILL_BUFFERS) {
				io_u_fill_buffer(td, io_u,
					td->o.min_bs[DDIR_WRITE],
					io_u->buflen);
			} else if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
				   !(td->flags & TD_F_COMPRESS))
				do_scramble = 1;
			if (td->flags & TD_F_VER_NONE) {
				populate_verify_io_u(td, io_u);
				do_scramble = 0;
			}
		} else if (io_u->ddir == DDIR_READ) {
		...

Note that "do_scramble" is only set to 1 if (td->flags &
TD_F_SCRAMBLE_BUFFERS) is true, AND (td->flags & TD_F_COMPRESS) is false.
If I'm reading this correctly, the TD_F_ flags indicate whether the
specified option was passed to fio by the user or script.


Thanks,

Bryan
