Return-Path: <fio-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31109 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726283AbgBRUfY (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 18 Feb 2020 15:35:24 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61C6F1005510
        for <fio@vger.kernel.org>; Tue, 18 Feb 2020 20:35:20 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 319068B55C
        for <fio@vger.kernel.org>; Tue, 18 Feb 2020 20:35:20 +0000 (UTC)
Subject: Re: [PATCH] fio: remove duplicate global definition of tsc_reliable
From: Eric Sandeen <sandeen@redhat.com>
References: <30587810-2ca6-2a7f-f89b-a4f820b28a11@redhat.com>
 <3d8e7a16-3fad-6cbf-ea04-78a0010d200d@redhat.com>
Message-ID: <3cc8915e-b054-8045-e046-1873ff9d353e@redhat.com>
Date: Tue, 18 Feb 2020 14:35:19 -0600
MIME-Version: 1.0
In-Reply-To: <3d8e7a16-3fad-6cbf-ea04-78a0010d200d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

On 2/6/20 11:52 AM, Eric Sandeen wrote:
> On 1/31/20 1:19 PM, Eric Sandeen wrote:
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> Newer gcc v10 complains about globals being defined twice due to
>> a new default -fno-common flag. This causes build failures:
> 
> Ping?
> 
> Thanks,
> -Eric

Ok, well, this is in Fedora now in any case, since I needed to fix the FTBFS.


