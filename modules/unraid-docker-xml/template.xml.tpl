<?xml version="1.0"?>
<Container version="2">
  <Name>${container_name != null ? container_name : ""}</Name>
  <Repository>${repository != null ? repository : ""}</Repository>
  <Registry>${registry != null ? registry : ""}</Registry>
  <Network>${network != null ? network : ""}</Network>
  <MyIP>${myip != null ? myip : ""}</MyIP>
  <Shell>${shell != null ? shell : ""}</Shell>
  <Privileged>${privileged != null ? privileged : ""}</Privileged>
  <Support>${support != null ? support : ""}</Support>
  <Project>${project != null ? project : ""}</Project>
  <Overview>${overview != null ? overview : ""}</Overview>
  <Category>${category != null ? category : ""}</Category>
  <WebUI>${webui != null ? webui : ""}</WebUI>
  <TemplateURL>${template_url != null ? template_url : ""}</TemplateURL>
  <Icon>${icon != null ? icon : ""}</Icon>
  <ExtraParams>${extra_params != null ? extra_params : ""}</ExtraParams>
  <PostArgs>${postargs != null ? postargs : ""}</PostArgs>
  <CPUset>${cpuset != null ? cpuset : ""}</CPUset>
  <DateInstalled>${date_installed != null ? date_installed : ""}</DateInstalled>
  <DonateText>${donate_text != null ? donate_text : ""}</DonateText>
  <DonateLink>${donate_link != null ? donate_link : ""}</DonateLink>
  <Requires>${requires != null ? requires : ""}</Requires>
%{ for config in configs ~}
  <Config Name="${config.name != null ? config.name : ""}" Target="${config.target != null ? config.target : ""}" Default="${config.default != null ? config.default : ""}" Mode="${config.mode != null ? config.mode : ""}" Description="${config.description != null ? config.description : ""}" Type="${config.type != null ? config.type : ""}" Display="${config.display != null ? config.display : ""}" Required="${config.required != null ? config.required : ""}" Mask="${config.mask != null ? config.mask : ""}">${config.value != null ? config.value : ""}</Config>
%{ endfor ~}
  <TailscaleStateDir/>
</Container>
