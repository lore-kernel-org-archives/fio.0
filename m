Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9513EB64DA
	for <fio@archiver.kernel.org>; Fri, 21 Jul 2023 01:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjGUBHO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 20 Jul 2023 21:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjGUBHN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Jul 2023 21:07:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774522719
        for <fio@vger.kernel.org>; Thu, 20 Jul 2023 18:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12EE761CD3
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 01:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0270DC433C8;
        Fri, 21 Jul 2023 01:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689901631;
        bh=ddyGq7bTRSwTtF4zAIscowCl2ssfRZl5PK/6WFKLhhk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mx2j1SA+bCPGq8wFRg07dvIrH4ZAKpPL7Gd8PBOnZ5ZzLUgleOle8jUk50RH7KrFk
         K1lqh4PqNB3W0XxCnw8yr5k2OI3FiFdEsJHZiAOQ/fqTjBY55Uvq4z8HUm9W3qShq+
         ccH67uUwGHPBR6L/wQfPCt31O/0/T1IKIbourkb5+gGfwh+hvb1vtckfq8+xJnYL/6
         IkScs1w7i2jajX2issXFGQz48lRK3wwjKOeUDSObnCaMxiF+LUD4FcApo60K4Sli03
         tBQldJXOa6rIedSXFfzjyBU9p5gs155OnFl+j2/StwOJfYdiIaNVZ4LyTPSX7Kz4g1
         1uf+vD5IpeyGA==
Message-ID: <ac531535-fad3-c336-4a7c-2dda04c3bae4@kernel.org>
Date:   Fri, 21 Jul 2023 10:07:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 4/5] cmdprio: Add support for per I/O priority hint
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
References: <20230720013114.28158-1-dlemoal@kernel.org>
 <20230720013114.28158-5-dlemoal@kernel.org>
 <7bf0279a-0d54-03ab-15a0-84ae1b89e62e@kernel.dk>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <7bf0279a-0d54-03ab-15a0-84ae1b89e62e@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/21/23 04:36, Jens Axboe wrote:
> On 7/19/23 7:31?PM, Damien Le Moal wrote:
>> diff --git a/engines/io_uring.c b/engines/io_uring.c
>> index f30a3c00..d55af6bc 100644
>> --- a/engines/io_uring.c
>> +++ b/engines/io_uring.c
>> @@ -157,6 +157,21 @@ static struct fio_option options[] = {
>>  		.category = FIO_OPT_C_ENGINE,
>>  		.group	= FIO_OPT_G_IOURING,
>>  	},
>> +	{
>> +		.name	= "cmdprio_hint",
>> +		.lname	= "Asynchronous I/O priority hint",
>> +		.type	= FIO_OPT_INT,
>> +		.off1	= offsetof(struct ioring_options,
>> +				   cmdprio_options.hint[DDIR_READ]),
>> +		.off2	= offsetof(struct ioring_options,
>> +				   cmdprio_options.hint[DDIR_WRITE]),
>> +		.help	= "Set asynchronous IO priority hint",
>> +		.minval	= IOPRIO_MIN_PRIO_HINT,
>> +		.maxval	= IOPRIO_MAX_PRIO_HINT,
>> +		.interval = 1,
>> +		.category = FIO_OPT_C_ENGINE,
>> +		.group	= FIO_OPT_G_IOURING,
>> +	},
>>  	{
>>  		.name	= "cmdprio",
>>  		.lname	= "Asynchronous I/O priority level",
>> @@ -195,6 +210,12 @@ static struct fio_option options[] = {
>>  		.type	= FIO_OPT_UNSUPPORTED,
>>  		.help	= "Your platform does not support I/O priority classes",
>>  	},
>> +	{
>> +		.name	= "cmdprio_hint",
>> +		.lname	= "Asynchronous I/O priority hint",
>> +		.type	= FIO_OPT_UNSUPPORTED,
>> +		.help	= "Your platform does not support I/O priority classes",
>> +	},
>>  	{
>>  		.name	= "cmdprio",
>>  		.lname	= "Asynchronous I/O priority level",
> 
> Since neither this nor libaio actually do anything with these values,
> why isn't this just a generic option? You could flag the two engines
> where it actually works with an engine flag, and check if it's set and
> we don't have that flag and error out in the generic code.

Hmmm. I would like to keep the async IO prio option definitions and storage
together with the cmdprio_options struct, which is common to both libaio and
iouring engines. If we move the hint option definition to be a generic one, we
cannot use that struct and would need a job field. I can make that work, but
that makes the code a little messier by spreading out the controls for async IO
prio.

I agree that we can drop the error output though as indeed the hint value is
unused on systems without hint support. But warning the user about the lack of
support is nice I think.

Checking the code again though, one thing I noticed is that iouring and libaio
cmdprio_xxx options definition is identical, modulo the group. So all these
definitions could be moved to engines/cmdprio.h as macros and IO engines
supporting these options can use these to add the options. The other option is
to move the definition of all these options to be generic ones and use the
engine flag trick you mention to indicate support.

-- 
Damien Le Moal
Western Digital Research

