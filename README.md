# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

## Install CumulusCI
## Dependent packages

```
ID                  Package ID          Package Name                 Namespace      Package Version ID  Version Name                 Version
──────────────────  ──────────────────  ───────────────────────────  ─────────────  ──────────────────  ───────────────────────────  ──────────
0A30b000000q7cXCAQ  033800000005GQwAAM  Contacts & Organizations     npe01          04t1E000000cn2oQAA  Release                      3.15.0.2
0A30b000000q7cZCAQ  033800000005GR6AAM  Recurring Donations          npe03          04t1E000000japAQAQ  Release                      3.20.0.2
0A30b000000q7caCAA  03380000000DuPvAAK  Relationships                npe4           04t2E000003ZS9yQAG  Release                      3.11.0.2
0A30b000000q7cbCAA  033800000009Q8TAAU  Affiliations                 npe5           04t2E000003kXEEQA2  Release                      3.9.0.2
0A30b000000q7cYCAQ  033800000005J4XAAU  Households                   npo02          04t1E000000yAh8QAE  Release                      3.13.0.2
0A30b000000q7ccCAA  033i0000000Gi57AAC  Nonprofit Success Pack       npsp           04t1Y000000ksIoQAI  Release                      3.190.0.29

ID                  Package ID          Package Name                 Namespace      Package Version ID  Version Name                 Version
──────────────────  ──────────────────  ───────────────────────────  ─────────────  ──────────────────  ───────────────────────────  ──────────
0A3g00000002SdGCAU  0331K0000019NkhQAE  datatableLwcFsc                             04t1K0000033LS2QAM  Filtering,Lookup,Case Match  1.11.0.1
0A3g00000002Sf9CAE  03330000000wDAbAAM  Salesforce Connected Apps    sf_com_apps    04t30000001DUvrAAG  Winter '16                   1.7.0.1
0A30b000000q7cxCAA  03330000001Ig8MAAS  Salesforce and Chatter Apps  sf_chttr_apps  04t30000001MEG8AAO  Summer '15                   1.11.0.1
0A3g00000002Rz1CAE  03341000000cnyKAAQ  AnyCalendar                                 04t41000002ZVhZAAW  Summer 2017                  1.8.0.1
0A30b000000q7cgCAA  03350000000DEz4AAG  Volunteers for Salesforce    GW_Volunteers  04t1T000000Ey6yQAC  Release                      3.121.0.3
0A30b000000q7cXCAQ  033800000005GQwAAM  Contacts & Organizations     npe01          04t1E000000cn2oQAA  Release                      3.15.0.2
0A30b000000q7cfCAA  033i0000000ElVOAA0  Power of Us Hub              pub            04ti0000000GSu9AAG  1.5                          1.5.0.1
0A30b000000q7ccCAA  033i0000000Gi57AAC  Nonprofit Success Pack       npsp           04t1Y000000ksIoQAI  Release                      3.190.0.29
```

## Install dependent packages

```
sfdx force:package:install -p 04t1E000000cn2oQAA
sfdx force:package:install -p 04t1E000000japAQAQ
sfdx force:package:install -p 04t2E000003ZS9yQAG
sfdx force:package:install -p 04t2E000003kXEEQA2
sfdx force:package:install -p 04t1E000000yAh8QAE
sfdx force:package:install -p 04t1Y000000ksIoQAI
```