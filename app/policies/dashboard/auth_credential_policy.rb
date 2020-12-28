module Dashboard
  class AuthCredentialPolicy < ApplicationPolicy
    def destroy?
      member_owns_record?
    end

    private

    def member_owns_record?
      session_info.member.id == record.member_id
    end
  end
end
