Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47849 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab3G2QXc (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 29 Jul 2013 12:23:32 -0400
Message-ID: <51F696E7.1070206@kernel.dk>
Date: Mon, 29 Jul 2013 10:23:03 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: --minimal does not work in client/server mode
References: <CAOtMX2if0xLLNngOm4uGgWcrze_61M+jCmHcv0pgNisYsWr_Dg@mail.gmail.com> <51F683EC.4090402@kernel.dk> <CAOtMX2ji_t2MOA_9akkyAkXd=R6sO7V1nWiBfesLFJ5SPg+fdw@mail.gmail.com>
In-Reply-To: <CAOtMX2ji_t2MOA_9akkyAkXd=R6sO7V1nWiBfesLFJ5SPg+fdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: asomers@gmail.com
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 07/29/2013 10:00 AM, asomers@gmail.com wrote:
> I found a few more things that need to be suppressed in terse mode.
> The updated patch is here.  In addition to working with JSON output,
> we also need to check that the patch doesn't break disk statistics.  I
> haven't tried using those at all yet.
> 
> https://gist.github.com/asomers/6105396

I would suggest making a show_thread_status_all() that does something ala:

void show_thread_status_all()
{
   if (is_backend)
       fio_server_send_ts(ts, rs);
   else if (output_format == FIO_OUTPUT_TERSE)
       show_thread_status_terse(ts, rs);
   else if (output_format == FIO_OUTPUT_JSON) {
       struct json_object *tmp = show_thread_status_json(ts, rs);

       json_array_add_value_object(array, tmp);
   } else
       show_thread_status(ts, rs);
}

which should work for all. If you could check and fix the json bit too,
bonus points, and I'll test and commit it. Thanks!


-- 
Jens Axboe

