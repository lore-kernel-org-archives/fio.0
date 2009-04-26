Return-Path: <fio-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:11065 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZDZNtG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 26 Apr 2009 09:49:06 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1550984rvb.1
        for <fio@vger.kernel.org>; Sun, 26 Apr 2009 06:49:06 -0700 (PDT)
Message-Id: <530FE590-63A6-4EEE-81EF-1BE87EC6A707@omner.org>
From: Joshua Aune <luken@omner.org>
In-Reply-To: <f3177b9e0904260644v578c4eb9m35c64ccf7b883479@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: What's the right way to measure latency?
Date: Sun, 26 Apr 2009 07:49:04 -0600
References: <f3177b9e0904260644v578c4eb9m35c64ccf7b883479@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: fio@vger.kernel.org


On Apr 26, 2009, at 7:44 AM, Chris Worley wrote:

> The results show two latency numbers: clat and slat... what are these?

slat is not there for the sync engines but exists for libaio, submit  
latency.  clat sounds like completion latency.

Josh
