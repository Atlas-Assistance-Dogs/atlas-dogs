import { LightningElement, api } from "lwc";

export default class VaccinationItem extends LightningElement {
    @api vaccinationName;
    @api vaccinationDate;
    next3Mnths = new Date();
    today = new Date();

    next3Mnths = this.next3Mnths.setDate(this.today.getDate() + 90);
    next3Mnths = new Date(this.next3Mnths);

    get colorCode() {
        const mydate = new Date(this.vaccinationDate);
        const code = mydate > this.today ? "greenColor" : "redColor";
        return code;
    }

    get isExpired() {
        const mydate = new Date(this.vaccinationDate);

        console.log("Date -" + mydate);
        console.log("Today -" + this.today);
        console.log("3 Months -" + this.next3Mnths);

        return mydate < this.today;
    }

    get isGood() {
        const mydate = new Date(this.vaccinationDate);
        return mydate > this.today && mydate > this.next3Mnths;
    }

    get abtToExpire() {
        const mydate = new Date(this.vaccinationDate);
        const res =
            mydate > this.today && mydate <= this.next3Mnths ? true : false;
        return res;
    }

    get vName() {
        const name = this.vaccinationName.replace("Expiration Date", "");
        return name;
    }
}
