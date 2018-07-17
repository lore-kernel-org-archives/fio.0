Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:35849 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729743AbeGQPEA (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 17 Jul 2018 11:04:00 -0400
Received: by mail-vk0-f65.google.com with SMTP id y9-v6so685061vky.3
        for <fio@vger.kernel.org>; Tue, 17 Jul 2018 07:31:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB116995DF0FE7729E290EEAB5AB5C0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <925A83423110DA4D836092D40AC7A7E8084E0DEE@APYOKXMS108.ap.sony.com> <AT5PR8401MB116995DF0FE7729E290EEAB5AB5C0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Tue, 17 Jul 2018 09:30:22 -0500
Message-ID: <CAB-428=sjscbp4UoagO41K102Ba=Ng5uoXhVgCO4Uix4+zEg_g@mail.gmail.com>
Subject: Re: [PATCH] idle-prof: append output cpu idleness data to terse log
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "Friendy.Su@sony.com" <Friendy.Su@sony.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "No.Tanaka@sony.com" <No.Tanaka@sony.com>, "Hajime.Tomura@sony.com" <Hajime.Tomura@sony.com>

On Tue, Jul 17, 2018 at 9:18 AM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf
>> Of Friendy.Su@sony.com
>> Sent: Tuesday, July 17, 2018 2:46 AM
>> To: fio@vger.kernel.org
>> Cc: No.Tanaka@sony.com; Hajime.Tomura@sony.com; Friendy.Su@sony.com
>> Subject: [PATCH] idle-prof: append output cpu idleness data to terse
>> log
>>
>> cpu idleness data only output to normal and json log,
>> also output to terse log.
>>
>> Signed-off-by: friendy-su <friendy.su@sony.com>
>> ---
>>  HOWTO      |  4 +++-
>>  idletime.c | 19 +++++++++++++++++++
>>  stat.c     |  2 ++
>>  3 files changed, 24 insertions(+), 1 deletion(-)
>>
>> diff --git a/HOWTO b/HOWTO
>> index 70eed280..497e8cb1 100644
>> --- a/HOWTO
>> +++ b/HOWTO
>> @@ -3564,8 +3564,10 @@ will be a disk utilization section.
>>  Below is a single line containing short names for each of the fields
>> in the
>>  minimal output v3, separated by semicolons::
>>
>> -
>> terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwi
> ...
>> +
>> terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwi
> ...
>
> Since the terse format is not self-describing, new fields require
> a version bump (see -terse-version).
>
> Maybe one of the versions should print out the field names as the first
> line, so it becomes self-describing.  I guess the json format already
> provides that functionality, so it might not be necessary.
>
How about adding an extra command option like --terse-header that
prints out the header only? It is hard to keep track of these version
changes in one place at the user manual or some blog post.
with a terse header command option, I can ignore the terse version and
adjust my test scripts to query the header first before running the
test, then pull the right column after the test finishes.
