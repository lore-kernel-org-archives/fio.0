Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:34235 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767Ab1FQTMK convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 17 Jun 2011 15:12:10 -0400
Received: from kpbe14.cbf.corp.google.com (kpbe14.cbf.corp.google.com [172.25.105.78])
	by smtp-out.google.com with ESMTP id p5HJC87t019213
	for <fio@vger.kernel.org>; Fri, 17 Jun 2011 12:12:08 -0700
Received: from yib19 (yib19.prod.google.com [10.243.65.83])
	by kpbe14.cbf.corp.google.com with ESMTP id p5HJBSi1018318
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Fri, 17 Jun 2011 12:12:01 -0700
Received: by yib19 with SMTP id 19so1521130yib.9
        for <fio@vger.kernel.org>; Fri, 17 Jun 2011 12:12:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DFAFED6.3070305@kernel.dk>
References: <1308080427-31011-1-git-send-email-egouriou@google.com>
	<1308257826-3342-1-git-send-email-egouriou@google.com>
	<4DFAFED6.3070305@kernel.dk>
Date: Fri, 17 Jun 2011 12:11:58 -0700
Message-ID: <BANLkTimvoO5Xn4-F1pu3X0PQ0t2Xwa42Qw@mail.gmail.com>
Subject: Re: [PATCH v2] Add ability to invoke fallocate() FALLOC_FL_KEEP_SIZE.
From: Eric Gouriou <egouriou@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

For the mailing-list record, v2 was also
Signed-off-by: Eric Gouriou <egouriou@google.com>

I had forgotten to re-insert in my local commit.

 Eric

On Fri, Jun 17, 2011 at 12:14 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-06-16 22:57, Eric Gouriou wrote:
>> Hi Jens, all,
>>
>> This is version 2 of the patch submitted earlier this week. Compared
>> to the initial version I removed the "fallocate_keep_size" option and,
>> as suggested, changed "fallocate" to be a string option. I elected
>> to provide both descriptive and numeric compatibility values for the
>> old boolean values. Let me know if you disagree with that choice.
>>
>> I removed the weak version of fallocate(). It is not required at this
>> point and not having it removed the problem of figuring what semantics
>> it should have if invoked.
>>
>> As always, feedback is appreciated.
>
> Thanks Eric, this looks good! Applied.
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
