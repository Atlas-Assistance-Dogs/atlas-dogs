import { LightningElement, wire,track} from 'lwc';
import fetchCourses from '@salesforce/apex/filterDataByRole.fetchCourses';

export default class FilterByRoleComponent extends LightningElement {

@track roles ;
@track courses;
showCourses = false;

value = [];

get options() {
    return [
        { label: 'Facilitator', value: 'Facilitator' },
        { label: 'Client', value: 'Client' },
        { label: 'Trainer', value: 'Trainer' },
        { label: 'Volunteer', value: 'Volunteer' },
    ];
}

handleChange(e) {

    this.value = e.detail.value;
  
    if(this.value != null ){
        this.roles = this.value.join(',');
    }
}

@wire(fetchCourses, { roles: '$roles' })
wiredData({ data, error }) {

  if (data) {
    this.courses = data;
    this.showCourses = true;
    
  } else if (error) {
     console.error('Error:', error);
  }

}

/*getCourses(){
    
    if(this.value != null){
       
        this.showCourses = true;
    }
    else {
      
        alert('please select role');
    }   
} */

handleDateEdit(){

    console.log('Save');
  }






}


/*get selectedRoles() {
    this.roles = this.value.join(',');
    console.log('Roles ' + this.roles);
    return this.value.join(',');
} */

/*  fetchCourses(this.roles)
            .then(result => {
                this.courses = result;
                console.log('Imperaative', result);
            })
            .catch(error => {
                this.error = error;
            }); */

///