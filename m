Return-Path: <fio-owner@vger.kernel.org>
Received: from mxe2.gs.com ([207.17.45.100]:25327 "EHLO mxeod01.gs.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751182AbYLCFJz convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 3 Dec 2008 00:09:55 -0500
From: "Baur, Eric" <Eric.Baur@gs.com>
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: terse output for IO latencies
Date: Wed, 3 Dec 2008 00:04:50 -0500
Message-ID: <4DCBAA39733E8048992FB7737126041910FFD9BE@gsmbnbp23es.firmwide.corp.gs.com>
In-Reply-To: <e2a756a20812021537j315f4f4ev95b7fa5c4d32ddcf@mail.gmail.com>
References: <4DCBAA39733E8048992FB7737126041910FFD998@gsmbnbp23es.firmwide.corp.gs.com> <e2a756a20812021537j315f4f4ev95b7fa5c4d32ddcf@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Daniel Buggie <danielabuggie@gmail.com>
Cc: fio@vger.kernel.org

In my haste, I overlooked the character preceding "sec" when reading the
source. Nonetheless, it seems preferable to maintain consistency in
reporting of latency stats in <=us rather than jumping to <=ms after
1000us.

Thanks for clarifying.

-Eric

-----Original Message-----
From: Daniel Buggie [mailto:danielabuggie@gmail.com] 
Sent: Tuesday, December 02, 2008 6:37 PM
To: Baur, Eric
Cc: fio@vger.kernel.org
Subject: Re: terse output for IO latencies

On Mon, Dec 1, 2008 at 11:45 AM, Baur, Eric <Eric.Baur@gs.com> wrote:
> In the HOWTO for fio, the terse output for IO latencies is described
as:
>
> "IO latencies: <=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000, >=2000"
>
> Output from certain test runs have been observed to have more than 11
> values for IO latencies, For example:
>
> 0.01%, 0.00%, 0.01%, 0.01%, 0.06%, 0.73%, 35.42%, 7.19%, 3.03%, 0.52%,
> 2.79%, 13.67%, 32.84%, 2.86%, 0.84%, 0.02%, 0.01%, 0.00%, 0.00%,
0.00%,
> 0.00%, 0.00%
>
> What are the proper labels for this output?
>
> Thanks,
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I had a similar question last week (not sure if the message got eaten
by the server or by the holiday here in the states).  From what my
very rusty C skills and the source tell me, it appears the terse
output gives the same values as the regular output.  The only
difference being that the terse output cannot skip the brackets that
have no hits.  So I believe the values can be derived from this block
of code from the source:

static void show_lat_u(double *io_u_lat_u)
{
        const char *ranges[] = { "2=", "4=", "10=", "20=", "50=",
"100=",
                                 "250=", "500=", "750=", "1000=", };

        show_lat(io_u_lat_u, FIO_IO_U_LAT_U_NR, ranges, "usec");
}

static void show_lat_m(double *io_u_lat_m)
{
        const char *ranges[] = { "2=", "4=", "10=", "20=", "50=",
"100=",
                                 "250=", "500=", "750=", "1000=",
"2000=",
                                 ">=2000=", };

In which case, the documentation should probably be updated to reflect
that. Can anyone familiar with the code confirm this?

Daniel
