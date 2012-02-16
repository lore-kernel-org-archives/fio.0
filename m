Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp202.iad.emailsrvr.com ([207.97.245.202]:51697 "EHLO
	smtp202.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab2BPT4g (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Feb 2012 14:56:36 -0500
Subject: Re: Formats for log files
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: multipart/mixed; boundary="Apple-Mail=_954710BF-AC78-45A9-9A6F-27031CB105C4"
From: Josh Carter <public@joshcarter.com>
In-Reply-To: <8C39003C166535489D52AF2C9D8C58BC1A316DBD@NTXBOIMBX04.micron.com>
Date: Thu, 16 Feb 2012 12:46:08 -0700
Message-Id: <EF8C77A9-96EC-42F3-BC18-535FDDD9B0DF@joshcarter.com>
References: <8C39003C166535489D52AF2C9D8C58BC1A316C92@NTXBOIMBX04.micron.com> <953A2B33-81B7-4ECC-9E21-4C6393CF8B7E@joshcarter.com> <8C39003C166535489D52AF2C9D8C58BC1A316D31@NTXBOIMBX04.micron.com>,<B53FFA03-CFB4-46BB-882A-602F045FAF24@joshcarter.com> <8C39003C166535489D52AF2C9D8C58BC1A316DBD@NTXBOIMBX04.micron.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: "Bill Hooper (whooper)" <whooper@micron.com>


--Apple-Mail=_954710BF-AC78-45A9-9A6F-27031CB105C4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi Bill,

Looking at the code, I believe you're correct, the bandwidth logging for =
mixed loads isn't right. While read and write logs are kept separate, =
only one direction's log will get flushed on each interval. Instead, fio =
should flush both directions.

I'm attaching a patch. Jens: could you take a look at this? I've tested =
both mixed and single-direction workloads, seems to work fine.

Best regards,
Josh


--Apple-Mail=_954710BF-AC78-45A9-9A6F-27031CB105C4
Content-Disposition: attachment;
	filename=0001-Fix-bandwidth-logging-for-mixed-read-write-workloads.patch
Content-Type: application/octet-stream;
	name="0001-Fix-bandwidth-logging-for-mixed-read-write-workloads.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=2094e3fb2641d5aa2f3c12a021fd6e1ecf0595a8de=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Josh=20Carter=20<public@joshcarter.com>=0A=
Date:=20Thu,=2016=20Feb=202012=2011:31:11=20+0000=0ASubject:=20[PATCH]=20=
Fix=20bandwidth=20logging=20for=20mixed=20read/write=20workloads.=0A=0A=
fio=20was=20maintaining=20separate=20read/write=20stats,=20but=20only=20=
one=20timer=20for=0Abw_avg_time.=20Whichever=20IO=20direction=20happened=20=
to=20cross=20the=20timer=20would=0Aget=20its=20interval=20logged;=20the=20=
other=20data=20direction=20would=20not.=20Now=20both=0Addir=20are=20=
logged=20each=20time=20we=20cross=20bw_avg_time.=0A=0AWhere=20intervals=20=
don't=20contain=20any=20activity=20in=20a=20given=20ddir,=20no=20log=0A=
entry=20is=20made.=0A---=0A=20stat.c=20|=20=20=2021=20=
+++++++++++++++------=0A=201=20files=20changed,=2015=20insertions(+),=20=
6=20deletions(-)=0A=0Adiff=20--git=20a/stat.c=20b/stat.c=0Aindex=20=
7e3b979..462f9ba=20100644=0A---=20a/stat.c=0A+++=20b/stat.c=0A@@=20=
-1291,16=20+1291,25=20@@=20void=20add_bw_sample(struct=20thread_data=20=
*td,=20enum=20fio_ddir=20ddir,=20unsigned=20int=20bs,=0A=20=09spent=20=3D=20=
mtime_since(&td->bw_sample_time,=20t);=0A=20=09if=20(spent=20<=20=
td->o.bw_avg_time)=0A=20=09=09return;=0A+=09=0A+=09/*=20=0A+=09=20*=20=
Compute=20both=20read=20and=20write=20rates=20for=20the=20interval.=0A+=09=
=20*/=0A+=09for=20(ddir=20=3D=20DDIR_READ;=20ddir=20<=3D=20DDIR_WRITE;=20=
ddir++)=20{=0A+=09=20=20=20=20if=20(td->stat_io_bytes[ddir]=20=3D=3D=20=
td->this_io_bytes[ddir])=0A+=09=09continue;=20/*=20No=20entries=20for=20=
interval=20*/=0A+=09=20=20=20=20=0A+=09=20=20=20=20rate=20=3D=20=
(td->this_io_bytes[ddir]=20-=20td->stat_io_bytes[ddir])=20*=0A+=09=09=
1000=20/=20spent=20/=201024;=0A+=09=20=20=20=20=
add_stat_sample(&ts->bw_stat[ddir],=20rate);=0A=20=0A-=09rate=20=3D=20=
(td->this_io_bytes[ddir]=20-=20td->stat_io_bytes[ddir])=20*=0A-=09=09=09=
1000=20/=20spent=20/=201024;=0A-=09add_stat_sample(&ts->bw_stat[ddir],=20=
rate);=0A-=0A-=09if=20(td->bw_log)=0A+=09=20=20=20=20if=20(td->bw_log)=0A=
=20=09=09add_log_sample(td,=20td->bw_log,=20rate,=20ddir,=20bs);=0A=20=0A=
+=09=20=20=20=20td->stat_io_bytes[ddir]=20=3D=20td->this_io_bytes[ddir];=0A=
+=09}=0A+=0A=20=09fio_gettime(&td->bw_sample_time,=20NULL);=0A-=09=
td->stat_io_bytes[ddir]=20=3D=20td->this_io_bytes[ddir];=0A=20}=0A=20=0A=20=
void=20add_iops_sample(struct=20thread_data=20*td,=20enum=20fio_ddir=20=
ddir,=0A--=20=0A1.7.7=0A=0A=

--Apple-Mail=_954710BF-AC78-45A9-9A6F-27031CB105C4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



On Feb 16, 2012, at 11:51 AM, Bill Hooper (whooper) wrote:

> Thanks for the reply. I ended doing something similar to your script =
consolidate the jobs. If the job was a read only or write only I found =
that I can add together the jobs based on the timestamps. The resulting =
data give me a good representation of the totals across the intervals.
>=20
> Unfortunately this all falls apart with mixed workloads. Have you done =
any analysis work with the log files produced by mixed workloads?
>=20
> Bill
> ________________________________________
> From: Josh Carter [public@joshcarter.com]
> Sent: Thursday, February 16, 2012 10:41 AM
> To: Bill Hooper (whooper)
> Subject: Re: Formats for log files
>=20
> Hi Bill,
>=20
> The times across jobs are accurate -- it's all coming from the same =
clock. Say you've got 4 jobs, you'll indeed see the time go from =
500-ish..end then hop back to 500-ish for the next job's log. The sample =
points won't be *exactly* the same, however. Job 1 might take a sample =
at 501ms, job 2 might not sample until 507ms. Fio samples when IOs are =
completed, so tests with longer-running IOs (like with large block =
sizes) will have more jitter.
>=20
> All jobs are using the same clock, however, so it's valid to plot jobs =
against each other, or do some analysis with binning, etc.. You may need =
to post-process the log file, e.g. adding a column for the job number. =
Example (using Ruby):
>=20
>    File.open("multi_job_test_bw-split.log", "w+") do |outfile|
>      File.open("multi_job_test_bw.log") do |infile|
>        job =3D 1
>        last_time =3D nil
>=20
>        infile.each_line do |line|
>          time, rate, ddir, bs =3D line.chomp.split(',')
>          time =3D time.to_i
>=20
>          # When time hops backwards, that means we're
>          # on the next job.
>          job +=3D 1 if (last_time && time < last_time)
>=20
>          outfile.puts "#{time},#{rate},#{rate},#{bs},#{job}"
>          last_time =3D time
>        end
>      end
>    end
>=20
> I haven't seen empty block sizes in the log -- sounds like a bug.
>=20
> Best regards,
> Josh
>=20
> On Feb 16, 2012, at 10:33 AM, Bill Hooper (whooper) wrote:
>=20
>> Thanks for the information. I suspected that was the format. I do =
notice that I do not always have the block size in the log. I am using =
version 2.0 and will try a more recent version.
>>=20
>> It appears that when I set the numjobs parameter the log files will =
contain the data from each job concatenated. I also notice that the =
times for each job is not synchronized between jobs. The question is how =
do I merge the data from each job to consolidate the data?
>>=20
>> Bill Hooper
>> Micron
>=20


--Apple-Mail=_954710BF-AC78-45A9-9A6F-27031CB105C4--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


