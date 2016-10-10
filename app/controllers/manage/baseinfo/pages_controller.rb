class Manage::Baseinfo::PagesController < Manage::BaseController

  def doctor
    @hospitals = Hospital.all
    @departments = Department.all
    @skills = Skill.all
    @grades = Grade.all
  end

  def project
    @tags = Tag.all
  end

end
